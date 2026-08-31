// DOM integration tests for the input bindings: R-generated markup
// (srcts/tests/html/, via gen-html.R) + real jQuery/Bootstrap + the actual
// built bsides.js bundle, driven through a faithful Shiny-stub binding
// lifecycle in jsdom.
//
// Run via: npm run test-dom
//
// This complements the shinytest2 e2e suite: no real browser or Shiny
// server, but fast, and it verifies binding logic and selector/markup
// agreement between R/ and srcts/.

import fs from 'node:fs'
import path from 'node:path'
import { fileURLToPath } from 'node:url'
import { JSDOM } from 'jsdom'
import esbuild from 'esbuild'

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../..')

const read = (f) => fs.readFileSync(path.join(root, f), 'utf8')
const html = (name) => read(path.join('srcts/tests/html', `${name}.html`))
const tick = (ms = 60) => new Promise((r) => setTimeout(r, ms))

const body = [
  'button', 'checkbox', 'checkbox-group', 'file', 'file-manual', 'form',
  'form-file', 'link', 'list-group',
  'menu', 'chip-group', 'chip-group-none', 'chip-group-select',
  'multi-select', 'multi-select-free', 'numeric', 'radio-group', 'range',
  'select', 'text-group', 'modal'
].map((n) => `<section data-component="${n}">${html(n)}</section>`).join('\n')

const dom = new JSDOM(
  `<!doctype html><html><head></head><body>${body}</body></html>`,
  { runScripts: 'outside-only', pretendToBeVisual: true, url: 'http://localhost/' }
)

const win = dom.window
const doc = win.document

// Shiny stub: records registrations, handlers, and setInputValue calls.
win.eval(`
  window.__registered = {};
  window.__handlers = {};
  window.__setInputValues = [];
  window.Shiny = {
    InputBinding: class InputBinding {
      getId(el) { return el.getAttribute('data-input-id') || el.id; }
      getType(el) { return null; }
      getRatePolicy(el) { return null; }
      initialize(el) {}
      getState(el) { throw 'Not implemented'; }
    },
    inputBindings: {
      register(binding, name) { window.__registered[name] = binding; }
    },
    addCustomMessageHandler(type, handler) { window.__handlers[type] = handler; },
    setInputValue(name, value, opts) {
      window.__setInputValues.push({ name, value, opts });
    },
    unbindAll() {},
    renderContentAsync: async (el, content, where) => {
      const h = typeof content === 'string' ? content : content.html;
      el.insertAdjacentHTML(where, h);
    }
  };
`)

// Upload scaffolding: a scripted shinyapp.makeRequest standing in for the
// WebSocket RPC leg, and a stub XMLHttpRequest standing in for the POST
// leg. Both record every call and are steered per test through
// __requestPlan / __postPlan; the defaults answer uploadInit with a job
// and complete each POST with a single full-size progress event. Either
// plan can park its call — on __deferredRequests or __deferredPosts —
// for the test to settle when it chooses.
win.eval(`
  window.__connected = true;
  window.__requests = [];
  window.__posts = [];
  window.__requestPlan = null;
  window.__postPlan = null;
  window.__deferredRequests = [];

  window.Shiny.shinyapp = {
    isConnected() { return window.__connected; },
    makeRequest(method, args, onSuccess, onError) {
      const call = { method, args };
      window.__requests.push(call);
      const plan = window.__requestPlan
        ? window.__requestPlan(call, window.__requests.length - 1)
        : null;
      // One job per file: each uploadInit gets its own id and url, so a
      // POST can be traced back to the file it was declared for.
      const ordinal = window.__requests.filter((r) => r.method === method).length;
      // Shiny's client never rejects a pending request when the socket
      // drops; a hung plan reproduces that, settling neither way.
      if (plan && plan.hang) {
        return;
      }
      // A deferred request is parked for the test to settle by hand,
      // standing in for a server slow to answer. Held open across the
      // awaits the caller makes, so a test can inspect what ran while it
      // was outstanding.
      if (plan && plan.defer) {
        window.__deferredRequests.push({ method, args, onSuccess, onError });
        return;
      }
      setTimeout(() => {
        if (plan && plan.error) {
          onError(plan.error);
        } else if (plan && 'value' in plan) {
          onSuccess(plan.value);
        } else if (method === 'uploadInit') {
          onSuccess({
            jobId: 'job' + ordinal,
            uploadUrl: '/session/tok/upload/job' + ordinal + '?w='
          });
        } else {
          onSuccess({});
        }
      }, 0);
    }
  };

  window.__deferredPosts = [];

  window.XMLHttpRequest = class StubXHR {
    constructor() {
      this.upload = {};
      this.status = 0;
      this.responseText = '';
      this.aborted = false;
    }
    open(method, url) { this.method = method; this.url = url; }
    setRequestHeader(name, value) {
      this.headers = this.headers || {};
      this.headers[name] = value;
    }
    send(body) {
      const call = {
        method: this.method,
        url: this.url,
        headers: this.headers,
        name: body && body.name,
        size: body && body.size
      };
      window.__posts.push(call);
      const plan = (window.__postPlan
        ? window.__postPlan(call, window.__posts.length - 1)
        : null) || {};
      if (plan.defer) {
        window.__deferredPosts.push(this);
        return;
      }
      setTimeout(() => {
        if (this.aborted) return;
        const loaded = plan.progress || [call.size];
        for (const n of loaded) {
          if (this.upload.onprogress) {
            this.upload.onprogress({ lengthComputable: true, loaded: n });
          }
        }
        this.status = plan.status || 200;
        this.responseText = plan.responseText || '';
        if (this.onload) this.onload();
      }, 0);
    }
    abort() {
      this.aborted = true;
      if (this.onabort) this.onabort();
    }
  };
`)

win.eval(read('node_modules/jquery/dist/jquery.js'))
win.eval(read('node_modules/bootstrap/dist/js/bootstrap.bundle.js'))
win.eval(read('inst/www/yonder/js/bsides.js'))

// The uploader and the validation helpers are internal to the bundle (an
// IIFE exporting nothing), so bundle them a second time under global names
// for direct unit tests. The footer is what publishes them: esbuild emits
// "use strict", and a strict eval keeps its own var scope instead of
// writing to the global object.
const expose = (entry, name) => win.eval(esbuild.buildSync({
  entryPoints: [path.join(root, entry)],
  bundle: true,
  format: 'iife',
  globalName: name,
  target: 'es2022',
  footer: { js: `window.${name} = ${name}` },
  write: false
}).outputFiles[0].text)

expose('srcts/src/components/upload.ts', '__upload')
expose('srcts/src/components/fileValidate.ts', '__validate')

const registered = win.__registered
const handlers = win.__handlers

// Shiny-like bind: find elements, initialize, subscribe with a recording
// callback that captures the value at event time.
function bind(name) {
  const binding = registered[name]
  if (!binding) throw new Error(`binding not registered: ${name}`)

  const els = [...binding.find(doc.body)]
  const events = []

  for (const el of els) {
    binding.initialize?.(el)
    binding.subscribe(el, (deferred) => {
      events.push({ id: binding.getId(el), deferred, value: binding.getValue(el) })
    })
  }

  return { binding, els, events }
}

const failures = []
let checks = 0

function check(label, cond, detail) {
  checks++
  if (!cond) failures.push(`FAIL ${label}${detail ? ` — ${JSON.stringify(detail)}` : ''}`)
}

const eq = (a, b) => JSON.stringify(a) === JSON.stringify(b)
const native = (el, type, Ctor = win.Event, init = {}) =>
  el.dispatchEvent(new Ctor(type, { bubbles: true, ...init }))

// ---- find() scope contract ----
// Shiny's BindScope is an element OR a jQuery object. renderContentAsync()
// with `where != "replace"` (used by modal.ts), insertUI(), and insertTab()
// all bind with the jQuery parent of the rendered node.
for (const name of Object.keys(registered)) {
  const binding = registered[name]
  let fromElement
  let fromJQuery

  try {
    fromElement = [...binding.find(doc.body)]
  } catch (e) {
    fromElement = e.message
  }

  try {
    fromJQuery = [...binding.find(win.jQuery(doc.body))]
  } catch (e) {
    fromJQuery = e.message
  }

  check(
    `${name}: find() accepts a jQuery scope`,
    Array.isArray(fromJQuery) &&
      Array.isArray(fromElement) &&
      fromJQuery.length === fromElement.length &&
      fromJQuery.every((el, i) => el === fromElement[i]),
    { fromElement, fromJQuery }
  )
}

// ---- button ----
{
  const { binding, els, events } = bind('bsides.button')
  const el = doc.getElementById('btn')
  check('button: found', els.includes(el))
  check('button: getType', binding.getType(el) === 'bsides.button')
  check('button: initial value 0', binding.getValue(el) === 0)
  el.click()
  el.click()
  check('button: clicks counted', binding.getValue(el) === 2, binding.getValue(el))
  check('button: 2 events, immediate', events.length === 2 && events.every((e) => e.deferred === false), events)
  binding.receiveMessage(el, { label: 'Go', disable: true })
  check('button: label updated', el.innerHTML === 'Go', el.innerHTML)
  check('button: disabled', el.disabled === true)
}

// ---- link ----
{
  const { binding, els, events } = bind('bsides.link')
  const el = doc.getElementById('lnk')
  check('link: found', els.includes(el))
  check('link: getType', binding.getType(el) === 'bsides.link')
  el.click()
  check('link: click counted', binding.getValue(el) === 1)
  check('link: immediate', events.length === 1 && events[0].deferred === false, events)
  binding.receiveMessage(el, { label: 'There' })
  check('link: label updated', el.innerHTML === 'There', el.innerHTML)
  binding.receiveMessage(el, { label: null })
  check('link: null label ignored', el.innerHTML === 'There', el.innerHTML)
}

// ---- checkbox ----
{
  const { binding, els, events } = bind('bsides.checkbox')
  const el = doc.getElementById('chk')
  const input = el.querySelector('.form-check-input')
  check('checkbox: found', els.includes(el))
  check('checkbox: initial false', binding.getValue(el) === false)
  input.checked = true
  native(input, 'change')
  check('checkbox: checked true', binding.getValue(el) === true)
  check('checkbox: immediate', events.length === 1 && events[0].deferred === false, events)
  binding.receiveMessage(el, { choice: 'Updated', value: false, disable: true })
  check('checkbox: choice html', el.querySelector('.form-check-label').innerHTML === 'Updated')
  check('checkbox: value applied', binding.getValue(el) === false)
  check('checkbox: disabled', input.disabled === true)
  check('checkbox: receiveMessage fired change', events.length === 2, events.length)
}

// ---- checkbox group ----
{
  const { binding, els, events } = bind('bsides.checkboxgroup')
  const el = doc.getElementById('chkgrp')
  const inputs = [...el.querySelectorAll('.form-check-input')]
  check('checkboxgroup: found', els.includes(el))
  check('checkboxgroup: getType', binding.getType(el) === 'bsides.checkboxgroup')
  inputs[0].checked = true
  inputs[2].checked = true
  native(inputs[2], 'change')
  check(
    'checkboxgroup: values',
    eq(binding.getValue(el), [inputs[0].value, inputs[2].value]),
    binding.getValue(el)
  )
  check('checkboxgroup: immediate', events.at(-1)?.deferred === false)
  binding.receiveMessage(el, { select: [inputs[1].value], disable: [inputs[0].value] })
  check('checkboxgroup: select applied', eq(binding.getValue(el), [inputs[1].value]), binding.getValue(el))
  check('checkboxgroup: disable applied', inputs[0].disabled === true && inputs[1].disabled === false)
}

// ---- radio group ----
{
  const { binding, els } = bind('bsides.radiogroup')
  const el = doc.getElementById('rad')
  const inputs = [...el.querySelectorAll('.form-check-input')]
  check('radiogroup: found', els.includes(el))
  inputs[1].checked = true
  native(inputs[1], 'change')
  check('radiogroup: value', binding.getValue(el) === inputs[1].value, binding.getValue(el))
  binding.receiveMessage(el, { select: [inputs[0].value] })
  check('radiogroup: select applied', binding.getValue(el) === inputs[0].value, binding.getValue(el))
  binding.receiveMessage(el, {
    options:
      '<div class="form-check"><input class="form-check-input" type="radio" value="New1" checked/></div>' +
      '<div class="form-check"><input class="form-check-input" type="radio" value="New2"/></div>'
  })
  check('radiogroup: options replaced', binding.getValue(el) === 'New1', binding.getValue(el))
}

// ---- range ----
{
  const { binding, els, events } = bind('bsides.range')
  check('range: found', els.length === 1, els.length)
  const target = els[0]
  const rangeInput = target.querySelector('.form-range')
  rangeInput.value = '75'
  native(rangeInput, 'change')
  check('range: numeric value', binding.getValue(target) === 75, binding.getValue(target))
  check('range: immediate', events.at(-1)?.deferred === false)
  binding.receiveMessage(target, { value: 20, disable: true })
  check('range: value applied', binding.getValue(target) === 20, binding.getValue(target))
  check('range: disabled prop', rangeInput.disabled === true)
}

// ---- numeric ----
{
  const { binding, els, events } = bind('bsides.numeric')
  const el = doc.getElementById('num')
  check('numeric: found', els.includes(el))
  check('numeric: initial value is a number', binding.getValue(el) === 5, binding.getValue(el))
  el.value = '7'
  native(el, 'input')
  check('numeric: input deferred', events.at(-1)?.deferred === true, events)
  check('numeric: value is a number, not a string', binding.getValue(el) === 7, binding.getValue(el))
  native(el, 'change')
  check('numeric: change immediate', events.at(-1)?.deferred === false, events)
  check('numeric: rate policy', eq(binding.getRatePolicy(el), { policy: 'debounce', delay: 250 }))

  // an empty field reports null, which reaches the server as NULL
  el.value = ''
  check('numeric: empty is null', binding.getValue(el) === null, binding.getValue(el))

  // format_no_sci() sends strings; a hand-built message may send numbers
  binding.receiveMessage(el, { value: '42', min: '0', max: '100', step: '2' })
  check('numeric: string value applied', binding.getValue(el) === 42, binding.getValue(el))
  check('numeric: min applied', el.min === '0', el.min)
  check('numeric: max applied', el.max === '100', el.max)
  check('numeric: step applied', el.step === '2', el.step)
  binding.receiveMessage(el, { value: 13 })
  check('numeric: number value applied', binding.getValue(el) === 13, binding.getValue(el))

  // an explicit null clears the attribute
  binding.receiveMessage(el, { min: null })
  check('numeric: null clears min', el.min === '', el.min)

  binding.receiveMessage(el, { disable: true })
  check('numeric: disabled prop', el.disabled === true)

  check('numeric: state', eq(binding.getState(el), { value: 13, min: '', max: '100', step: '2' }), binding.getState(el))

  // no getType(): values are sent under the bare id, and an empty field
  // reports NULL rather than shiny's NA
  check('numeric: no input type', binding.getType(el) === null || binding.getType(el) === undefined, binding.getType(el))
}

// ---- select ----
{
  const { binding, els, events } = bind('bsides.select')
  const el = doc.getElementById('sel')
  check('select: found', els.includes(el))
  el.value = 'S2'
  native(el, 'change')
  check('select: value', binding.getValue(el) === 'S2')
  check('select: immediate', events.at(-1)?.deferred === false)
  binding.receiveMessage(el, { select: 'S3', disable: ['S1'] })
  check('select: select applied', binding.getValue(el) === 'S3', binding.getValue(el))
  check('select: disable applied', el.querySelector('option[value="S1"]').disabled)
  binding.receiveMessage(el, { options: '<option value="N1">N1</option><option value="N2" selected>N2</option>' })
  check('select: options replaced', binding.getValue(el) === 'N2', binding.getValue(el))
}

// ---- text ----
{
  const { binding, els, events } = bind('bsides.text')
  const el = doc.getElementById('frmtext')
  check('text: found', els.includes(el))
  el.value = 'abc'
  native(el, 'input')
  check('text: input deferred', events.at(-1)?.deferred === true, events)
  native(el, 'change')
  check('text: change immediate', events.at(-1)?.deferred === false, events)
  check('text: value', binding.getValue(el) === 'abc')
  check('text: rate policy', eq(binding.getRatePolicy(el), { policy: 'debounce', delay: 250 }))
  binding.receiveMessage(el, { value: 'xyz' })
  check('text: value applied', binding.getValue(el) === 'xyz')
  el.value = ''
}

// ---- text group ----
{
  const { binding, els, events } = bind('bsides.textgroup')
  const el = doc.getElementById('txtgrp')
  const input = el.querySelector('input')
  check('textgroup: found', els.includes(el))
  check('textgroup: empty is null', binding.getValue(el) === null)
  input.value = '42'
  native(input, 'input')
  check('textgroup: joined value', binding.getValue(el) === '$42', binding.getValue(el))
  check('textgroup: input deferred', events.at(-1)?.deferred === true)
  binding.receiveMessage(el, { value: '99', disable: true })
  check('textgroup: value applied', binding.getValue(el) === '$99', binding.getValue(el))
  check('textgroup: disabled', input.disabled === true)
}

// ---- list group ----
{
  const { binding, els, events } = bind('bsides.listgroup')
  const el = doc.getElementById('lst')
  const items = [...el.querySelectorAll('.list-group-item-action')]
  check('listgroup: found', els.includes(el))
  items[1].click()
  check('listgroup: click toggles active', eq(binding.getValue(el), ['Item 2']), binding.getValue(el))
  check('listgroup: immediate', events.at(-1)?.deferred === false)
  items[1].click()
  check('listgroup: click untoggles', eq(binding.getValue(el), []), binding.getValue(el))
  binding.receiveMessage(el, { select: ['Item 1', 'Item 3'] })
  check('listgroup: update select', eq(binding.getValue(el), ['Item 1', 'Item 3']), binding.getValue(el))
  check('listgroup: update fired change', events.at(-1)?.value.length === 2, events.at(-1))
  binding.receiveMessage(el, { disable: ['Item 2'] })
  check('listgroup: disable class', items[1].classList.contains('disabled'))
}

// ---- menu ----
{
  const { binding, els, events } = bind('bsides.menu')
  const el = doc.getElementById('mnu')
  const choices = [...el.querySelectorAll('.dropdown-item')]
  check('menu: found', els.includes(el))
  choices[0].click()
  check('menu: click stores value', binding.getValue(el) === 'One', binding.getValue(el))
  check('menu: immediate', events.at(-1)?.deferred === false)
  binding.receiveMessage(el, { label: 'Pick', select: 'Two', disable: ['One'] })
  check('menu: label applied', el.querySelector('.dropdown-toggle').innerHTML === 'Pick')
  check('menu: select applied', binding.getValue(el) === 'Two', binding.getValue(el))
  check('menu: disable applied', choices[0].disabled === true)
  check('menu: select fired change', events.at(-1)?.value === 'Two', events.at(-1))
}

// ---- form ----
{
  const { binding, els, events } = bind('bsides.form')
  const el = doc.getElementById('frm')
  check('form: found', els.includes(el))

  // Simulate Shiny freezing a child input change.
  win.eval(`
    (function () {
      const el = document.getElementById('frmtext');
      jQuery(el).trigger(jQuery.Event('shiny:inputchanged', {
        el: el, name: 'frmtext', value: 'held-back', inputType: '', priority: 'immediate'
      }));
    })()
  `)

  el.querySelector('.bsides-input-form-submit').click()
  const sent = win.__setInputValues
  check(
    'form: replays child inputs on submit',
    sent.some((s) => s.name === 'frmtext' && s.value === 'held-back' && s.opts?.priority === 'event'),
    sent
  )
  check('form: value is submit button value', binding.getValue(el) === 'go', binding.getValue(el))
  check('form: submit fired event', events.at(-1)?.deferred === false, events)

  const before = events.length
  binding.receiveMessage(el, { submit: 'go' })
  check('form: receiveMessage submit clicks', events.length === before + 1, events.length)
}

// ---- chip-group ----
{
  const { binding, els, events } = bind('bsides.chipgroup')

  // Toggle-only chip group: choices Red/Green/Blue over r/g/b, no select
  // argument -> the constructor default (select = values) checks every
  // chip.
  const el = doc.getElementById('cg')
  await tick(20) // let Lit render

  const chip = (root, value) =>
    [...root.querySelectorAll('bsides-chip')].find((c) => c.value === value)

  check('chipgroup: found', els.includes(el))
  check('chipgroup: getType', binding.getType(el) === 'bsides.chipgroup')
  check('chipgroup: all checked by default', eq(binding.getValue(el), ['r', 'g', 'b']), binding.getValue(el))
  check('chipgroup: chips rendered', el.querySelectorAll('bsides-chip').length === 3)
  check(
    'chipgroup: chip renders choice label',
    chip(el, 'r').textContent.trim() === 'Red',
    chip(el, 'r').textContent
  )

  // The chip group has no editing UI at all.
  check('chipgroup: no text input', el.querySelector('input') === null)
  check('chipgroup: no menu', el.querySelector('.dropdown-menu') === null)
  check('chipgroup: no remove buttons', el.querySelector('.btn-close') === null)

  // Toggle-button semantics + type classes.
  check('chipgroup: chip carries type class', chip(el, 'r').classList.contains('chip-primary'))
  check('chipgroup: checked aria-pressed', chip(el, 'r').getAttribute('aria-pressed') === 'true')
  check('chipgroup: checked chip shows check icon', chip(el, 'r').querySelector('.chip-check') !== null)

  chip(el, 'r').click()
  await tick(20)
  check('chipgroup: click unchecks chip', eq(binding.getValue(el), ['g', 'b']), binding.getValue(el))
  check('chipgroup: change event immediate', events.at(-1)?.deferred === false)
  check('chipgroup: unchecked aria-pressed', chip(el, 'r').getAttribute('aria-pressed') === 'false')
  check('chipgroup: unchecked chip drops check icon', chip(el, 'r').querySelector('.chip-check') === null)

  // Keyboard toggles (Enter/Space) on the focused chip.
  native(chip(el, 'g'), 'keydown', win.KeyboardEvent, { key: ' ' })
  await tick(20)
  check('chipgroup: space toggles chip', eq(binding.getValue(el), ['b']), binding.getValue(el))
  native(chip(el, 'g'), 'keydown', win.KeyboardEvent, { key: 'Enter' })
  await tick(20)
  check('chipgroup: enter toggles chip', eq(binding.getValue(el), ['g', 'b']), binding.getValue(el))

  // Checked values report in choices order regardless of toggle order:
  // r was re-checked last but still reports first.
  chip(el, 'r').click()
  await tick(20)
  check('chipgroup: value in choices order', eq(binding.getValue(el), ['r', 'g', 'b']), binding.getValue(el))

  // Explicit select = NULL renders every chip unchecked (no checked
  // attribute) — the empty-selection construction.
  const el3 = doc.getElementById('cg3')
  check('chipgroup: explicit NULL select checks nothing', eq(binding.getValue(el3), []), binding.getValue(el3))
  check('chipgroup: explicit NULL select aria-pressed', chip(el3, 'r').getAttribute('aria-pressed') === 'false')

  // Preset element: initial checked from the attribute, custom type.
  const el2 = doc.getElementById('cg2')
  check('chipgroup: initial select from attribute', eq(binding.getValue(el2), ['m']), binding.getValue(el2))
  check('chipgroup: custom type class', chip(el2, 'm').classList.contains('chip-warning'))

  // receiveMessage select REPLACES the checked set (no merging).
  binding.receiveMessage(el2, { select: ['s', 'l'] })
  await tick(20)
  check('chipgroup: select replaces checked', eq(binding.getValue(el2), ['s', 'l']), binding.getValue(el2))

  // Shiny serializes length-1 vectors as scalars; normalized to an array.
  binding.receiveMessage(el2, { select: 'm' })
  await tick(20)
  check('chipgroup: scalar select normalized', eq(binding.getValue(el2), ['m']), binding.getValue(el2))

  // Unknown select values are dropped with a console warning.
  win.eval(`
    window.__warnings = [];
    console.warn = (...args) => window.__warnings.push(args.join(' '));
  `)
  binding.receiveMessage(el2, { select: ['s', 'nope'] })
  await tick(20)
  check('chipgroup: unknown select value dropped', eq(binding.getValue(el2), ['s']), binding.getValue(el2))
  check(
    'chipgroup: unknown select value warns',
    win.__warnings.some((w) => w.includes('nope')),
    win.__warnings
  )

  // Replacing choices drops checked values whose chip no longer exists
  // and reports the new value.
  binding.receiveMessage(el2, { select: ['s', 'm'] })
  await tick(20)
  binding.receiveMessage(el2, {
    choices: [{ label: 'Medium', value: 'm' }, { label: 'Giant', value: 'xl' }]
  })
  await tick(20)
  check('chipgroup: choices replacement prunes checked', eq(binding.getValue(el2), ['m']), binding.getValue(el2))
  check('chipgroup: prune reported to server', eq(events.at(-1)?.value, ['m']), events.at(-1))
  check('chipgroup: chips re-rendered from choices', el2.querySelectorAll('bsides-chip').length === 2)

  // disable stops toggling; enable restores it.
  binding.receiveMessage(el2, { disable: true })
  await tick(20)
  chip(el2, 'xl').click()
  await tick(20)
  check('chipgroup: disabled chips do not toggle', eq(binding.getValue(el2), ['m']), binding.getValue(el2))
  binding.receiveMessage(el2, { enable: true })
  await tick(20)
  chip(el2, 'xl').click()
  await tick(20)
  check('chipgroup: re-enabled chips toggle', eq(binding.getValue(el2), ['m', 'xl']), binding.getValue(el2))

  // unsubscribe aborts the listener: further changes are not reported.
  const before = events.length
  binding.unsubscribe(el2)
  chip(el2, 'xl').click()
  await tick(20)
  check('chipgroup: unsubscribed element is silent', events.length === before, events.length - before)
}

// ---- multi-select ----
{
  const { binding, els, events } = bind('bsides.multiselect')

  // edit = "choices" input: choices Red/Green/Blue over r/g/b, select "r".
  const el = doc.getElementById('ms')
  await tick(20)

  const chip = (root, value) =>
    [...root.querySelectorAll('bsides-chip')].find((c) => c.value === value)
  const input = el.querySelector('.multi-select-input')
  const menu = () => el.querySelector('.dropdown-menu')
  const items = () =>
    [...el.querySelectorAll('.dropdown-item')].map((n) => n.textContent.trim())

  check('multiselect: found', els.includes(el))
  check('multiselect: getType', binding.getType(el) === 'bsides.multiselect')
  check('multiselect: initial chips from attribute', eq(binding.getValue(el), ['r']), binding.getValue(el))
  check(
    'multiselect: chip renders choice label',
    chip(el, 'r').textContent.trim() === 'Red',
    chip(el, 'r').textContent
  )

  // Multi-select chips do not toggle: not checkable, no check icon, but
  // removable and type-filled.
  check('multiselect: chip not checkable', chip(el, 'r').getAttribute('aria-pressed') === null)
  check('multiselect: chip has no check icon', chip(el, 'r').querySelector('.chip-check') === null)
  check('multiselect: chip carries type class', chip(el, 'r').classList.contains('chip-primary'))
  check('multiselect: chip removable', chip(el, 'r').querySelector('.btn-close') !== null)

  // Field structure: one bordered field wraps the chips and the input;
  // the chips wrapper is semantics-only (role=group over display:
  // contents); the caret sits outside the scrollable content; the menu is
  // anchored below the field, not inside it.
  const field = el.querySelector('.multi-select-field')
  const content = el.querySelector('.multi-select-field-content')
  const chipsWrapper = el.querySelector('.multi-select-chips')
  const caret = () => el.querySelector('.multi-select-caret')
  check('multiselect: field wraps content', content !== null && content.parentElement === field)
  check('multiselect: chips wrapper in content', chipsWrapper.parentElement === content)
  check('multiselect: chips wrapper keeps group role', chipsWrapper.getAttribute('role') === 'group')
  check('multiselect: input in content', input.parentElement === content)
  check('multiselect: caret outside scroll content', caret()?.parentElement === field)
  check('multiselect: caret aria-hidden', caret()?.getAttribute('aria-hidden') === 'true')
  check('multiselect: menu outside the field', menu().parentElement === el)

  // The menu is a manual popover exactly when the engine supports the
  // Popover API; otherwise the absolute fallback positioning applies.
  // Either way the menu logic below runs on the same .show class.
  const popoverSupported =
    typeof win.HTMLElement.prototype.showPopover === 'function'
  check(
    'multiselect: menu popover attribute tracks support',
    (menu().getAttribute('popover') === 'manual') === popoverSupported,
    { popoverSupported, attr: menu().getAttribute('popover') }
  )

  // Combobox ARIA wiring.
  check('multiselect: combobox role', input.getAttribute('role') === 'combobox')
  check('multiselect: aria-autocomplete list', input.getAttribute('aria-autocomplete') === 'list')
  check('multiselect: aria-controls menu', input.getAttribute('aria-controls') === menu().id, menu().id)
  check('multiselect: menu role listbox', menu().getAttribute('role') === 'listbox')
  check('multiselect: menu hidden initially', !menu().classList.contains('show'))

  // Focus opens the menu; ALL choices are listed; members are checked in
  // place rather than hidden.
  native(input, 'focus', win.FocusEvent, { bubbles: false })
  await tick(20)
  check('multiselect: focus opens menu', menu().classList.contains('show'))
  check('multiselect: aria-expanded true', input.getAttribute('aria-expanded') === 'true')
  check('multiselect: caret marks open', caret().classList.contains('open'))
  check('multiselect: all choices listed', eq(items(), ['Red', 'Green', 'Blue']), items())

  const option = (label) =>
    [...el.querySelectorAll('button.dropdown-item')].find(
      (n) => n.textContent.trim() === label
    )
  check('multiselect: member option checkmarked', option('Red').querySelector('.option-check') !== null)
  check('multiselect: member option aria-selected', option('Red').getAttribute('aria-selected') === 'true')
  check('multiselect: non-member no checkmark', option('Green').querySelector('.option-check') === null)
  check('multiselect: non-member aria-selected', option('Green').getAttribute('aria-selected') === 'false')

  // Clicking a non-member adds it; the menu stays open.
  option('Green').click()
  await tick(20)
  check('multiselect: click adds member', eq(binding.getValue(el), ['r', 'g']), binding.getValue(el))
  check('multiselect: menu stays open after add', menu().classList.contains('show'))
  check('multiselect: added option checkmarked', option('Green').querySelector('.option-check') !== null)

  // Clicking a member removes it (toggle-from-list).
  option('Red').click()
  await tick(20)
  check('multiselect: click removes member', eq(binding.getValue(el), ['g']), binding.getValue(el))
  check('multiselect: removed option unchecked', option('Red').querySelector('.option-check') === null)

  // Typing filters across all choices; no matches renders a disabled item.
  input.value = 'blu'
  native(input, 'input')
  await tick(20)
  check('multiselect: typing filters by label', eq(items(), ['Blue']), items())
  input.value = 'zz'
  native(input, 'input')
  await tick(20)
  check('multiselect: no matches item', eq(items(), ['No matches']), items())

  // Free text is rejected at edit = "choices".
  input.value = 'Purple'
  native(input, 'input')
  native(input, 'keydown', win.KeyboardEvent, { key: 'Enter' })
  await tick(20)
  check('multiselect: free text rejected', eq(binding.getValue(el), ['g']), binding.getValue(el))
  check('multiselect: rejected text kept', input.value === 'Purple')

  // Escape closes first (text kept), clears text second.
  native(input, 'keydown', win.KeyboardEvent, { key: 'Escape' })
  await tick(20)
  check('multiselect: escape closes menu', !menu().classList.contains('show'))
  check('multiselect: escape keeps text', input.value === 'Purple')
  native(input, 'keydown', win.KeyboardEvent, { key: 'Escape' })
  await tick(20)
  check('multiselect: second escape clears text', input.value === '')
  check('multiselect: caret marks closed', !caret().classList.contains('open'))

  // Clicking the field — its padding, not the input or a chip — focuses
  // the input and opens the menu.
  native(input, 'blur', win.FocusEvent, { bubbles: false })
  await tick(20)
  check('multiselect: blur closes menu', !menu().classList.contains('show'))
  native(field, 'mousedown', win.MouseEvent)
  await tick(20)
  check('multiselect: field click focuses input', doc.activeElement === input)
  check('multiselect: field click opens menu', menu().classList.contains('show'))

  // With the input still focused (menu closed by Escape), a field click
  // reopens the menu — the open comes from the handler, not only focus.
  native(input, 'keydown', win.KeyboardEvent, { key: 'Escape' })
  await tick(20)
  native(field, 'mousedown', win.MouseEvent)
  await tick(20)
  check('multiselect: field click reopens when focused', menu().classList.contains('show'))
  native(input, 'keydown', win.KeyboardEvent, { key: 'Escape' })
  await tick(20)

  // Arrows open the menu and move the active option; Enter toggles it.
  const active = () => el.querySelector('.dropdown-item.active')?.textContent.trim()
  native(input, 'keydown', win.KeyboardEvent, { key: 'ArrowDown' })
  await tick(20)
  check('multiselect: arrow down opens and activates', active() === 'Red', active())
  check(
    'multiselect: aria-activedescendant tracks active',
    input.getAttribute('aria-activedescendant') === el.querySelector('.dropdown-item.active').id
  )
  native(input, 'keydown', win.KeyboardEvent, { key: 'ArrowUp' })
  await tick(20)
  check('multiselect: arrow up wraps to last', active() === 'Blue', active())
  native(input, 'keydown', win.KeyboardEvent, { key: 'Enter' })
  await tick(20)
  check('multiselect: enter adds active option', eq(binding.getValue(el), ['g', 'b']), binding.getValue(el))

  // With nothing active, Enter falls back to a unique exact-label match —
  // toggling membership, so an exact match on a member removes it.
  input.value = 'green'
  native(input, 'input')
  native(input, 'keydown', win.KeyboardEvent, { key: 'Escape' }) // close; active resets
  native(input, 'keydown', win.KeyboardEvent, { key: 'Enter' })
  await tick(20)
  check('multiselect: exact match toggles member off', eq(binding.getValue(el), ['b']), binding.getValue(el))
  input.value = ''

  // Backspace in an empty input removes the last chip.
  native(input, 'keydown', win.KeyboardEvent, { key: 'Backspace' })
  await tick(20)
  check('multiselect: backspace removes last', eq(binding.getValue(el), []), binding.getValue(el))

  // The close button removes a chip; the value reported is post-removal.
  binding.receiveMessage(el, { select: ['r', 'g'] })
  await tick(20)
  check('multiselect: update select replaces', eq(binding.getValue(el), ['r', 'g']), binding.getValue(el))
  chip(el, 'r').querySelector('.btn-close').click()
  await tick(20)
  check('multiselect: close removes chip', eq(binding.getValue(el), ['g']), binding.getValue(el))
  check('multiselect: server sees post-removal value', eq(events.at(-1)?.value, ['g']), events.at(-1))

  // Scalar select normalized; unknown values dropped with a warning at
  // edit = "choices".
  binding.receiveMessage(el, { select: 'b' })
  await tick(20)
  check('multiselect: scalar select normalized', eq(binding.getValue(el), ['b']), binding.getValue(el))
  win.eval(`
    window.__warnings = [];
    console.warn = (...args) => window.__warnings.push(args.join(' '));
  `)
  binding.receiveMessage(el, { select: ['b', 'nope'] })
  await tick(20)
  check('multiselect: unknown select value dropped', eq(binding.getValue(el), ['b']), binding.getValue(el))
  check(
    'multiselect: unknown select value warns',
    win.__warnings.some((w) => w.includes('nope')),
    win.__warnings
  )

  // Replacing choices prunes members no longer offered.
  binding.receiveMessage(el, {
    choices: [{ label: 'Crimson', value: 'r' }, { label: 'Blue', value: 'b' }]
  })
  await tick(20)
  check('multiselect: choices replacement keeps member', eq(binding.getValue(el), ['b']), binding.getValue(el))
  binding.receiveMessage(el, { choices: [{ label: 'Crimson', value: 'r' }] })
  await tick(20)
  check('multiselect: choices replacement prunes member', eq(binding.getValue(el), []), binding.getValue(el))

  // placeholder / max / disable / enable updates.
  binding.receiveMessage(el, { placeholder: 'Pick one' })
  await tick(20)
  check('multiselect: placeholder applied', input.placeholder === 'Pick one', input.placeholder)

  binding.receiveMessage(el, { select: 'r', max: 1 })
  await tick(20)
  check('multiselect: at max disables input', input.disabled === true)
  binding.receiveMessage(el, { max: 5 })
  await tick(20)
  check('multiselect: raising max re-enables', input.disabled === false)

  binding.receiveMessage(el, { disable: true })
  await tick(20)
  check('multiselect: disable applied', input.disabled === true)
  binding.receiveMessage(el, { enable: true })
  await tick(20)
  check('multiselect: enable applied', input.disabled === false)

  // The placeholder shows only while there are no chips (a chip beside
  // placeholder text reads like two values).
  check('multiselect: placeholder hidden with chips', input.getAttribute('placeholder') === null)
  chip(el, 'r').querySelector('.btn-close').click()
  await tick(20)
  check('multiselect: placeholder returns when empty', input.placeholder === 'Pick one', input.placeholder)

  // ---- free input (edit = "free", no choices): pure tag entry ----
  const el2 = doc.getElementById('msfree')
  const input2 = el2.querySelector('.multi-select-input')

  check('multiselect: free has no menu', el2.querySelector('.dropdown-menu') === null)
  check('multiselect: free has no caret', el2.querySelector('.multi-select-caret') === null)
  check('multiselect: free input not combobox', input2.getAttribute('role') === null)
  check('multiselect: free initial empty', eq(binding.getValue(el2), []), binding.getValue(el2))
  check('multiselect: placeholder from attribute', input2.placeholder === 'Add a tag')

  input2.value = 'Tag1'
  native(input2, 'keydown', win.KeyboardEvent, { key: 'Enter' })
  await tick(20)
  check('multiselect: enter creates chip', eq(binding.getValue(el2), ['Tag1']), binding.getValue(el2))
  check('multiselect: input cleared', input2.value === '')

  input2.value = '   '
  native(input2, 'keydown', win.KeyboardEvent, { key: 'Enter' })
  await tick(20)
  check('multiselect: blank text ignored', eq(binding.getValue(el2), ['Tag1']), binding.getValue(el2))

  input2.value = 'Tag1'
  native(input2, 'keydown', win.KeyboardEvent, { key: 'Enter' })
  await tick(20)
  check('multiselect: duplicate rejected', eq(binding.getValue(el2), ['Tag1']), binding.getValue(el2))
  check('multiselect: duplicate text kept', input2.value === 'Tag1')
  input2.value = ''

  // Free mode select updates accept arbitrary values.
  binding.receiveMessage(el2, { select: ['alpha', 'beta'] })
  await tick(20)
  check('multiselect: free select replaces', eq(binding.getValue(el2), ['alpha', 'beta']), binding.getValue(el2))

  // unsubscribe aborts the listener: further changes are not reported.
  const before = events.length
  binding.unsubscribe(el2)
  input2.value = 'Late'
  native(input2, 'keydown', win.KeyboardEvent, { key: 'Enter' })
  await tick(20)
  check('multiselect: unsubscribed element is silent', events.length === before, events.length - before)
}

// ---- modal ----
{
  const { binding, els, events } = bind('bsides.modal')
  const el = doc.getElementById('mdl')
  check('modal: found', els.includes(el))
  check('modal: no instance yet', binding.getValue(el) === null)

  handlers['bsides:modalShow']({ modal: 'mdl' })
  await tick(100)
  check('modal: shown', binding.getValue(el) === 'shown', binding.getValue(el))
  check('modal: shown event fired', events.some((e) => e.value === 'shown'), events)

  handlers['bsides:modalClose']({})
  await tick(400)
  check('modal: hidden after modalClose', binding.getValue(el) === 'hidden', binding.getValue(el))
}

// ---- file ----
{
  const { binding, els, events } = bind('bsides.file')
  const el = doc.getElementById('upl')
  const input = el.querySelector('.file-input')

  win.__connected = true
  win.__requests = []
  win.__posts = []
  win.__requestPlan = null
  win.__postPlan = null
  win.__deferredPosts = []
  win.__deferredRequests = []

  const file = (name, bytes, type = '') =>
    new win.File(['x'.repeat(bytes)], name, { type })

  check('file: found', els.includes(el))
  // The server sets input$<id> at uploadEnd, so bind time is all the
  // binding answers — the stock file input's null/"shiny.file" pair.
  check('file: getValue is null', binding.getValue(el) === null)
  check('file: getType', binding.getType(el) === 'shiny.file')

  // R attributes reach the component's properties.
  check('file: multiple from attribute', el.multiple === true)
  check('file: accept from attribute', el.accept === '.csv,text/csv', el.accept)
  check('file: max size from data attribute', el.maxSize === 5242880, el.maxSize)

  await el.updateComplete

  check('file: renders a real file input', input !== null)
  check('file: inner input carries accept/multiple',
    input.getAttribute('accept') === '.csv,text/csv' && input.multiple === true)
  // Without this, Shiny's own file binding would claim the inner input.
  check('file: inner input opts out of shiny binding',
    input.hasAttribute('data-shiny-no-bind-input'))
  check('file: no list before a selection', el.querySelector('.file-list') === null)

  // A batch, driven through the picker path.
  win.__postPlan = () => ({ progress: [5, 10] })
  el.upload([file('a.csv', 10, 'text/csv')])
  await el.updateComplete

  check('file: busy while uploading', el.getAttribute('aria-busy') === 'true')
  check('file: picker disabled while uploading', input.disabled === true)
  check('file: row rendered', el.querySelectorAll('.file-item').length === 1)
  check('file: row names the file',
    el.querySelector('.file-item-name').textContent === 'a.csv')
  check('file: row shows a formatted size',
    el.querySelector('.file-item-size').textContent === '10 B',
    el.querySelector('.file-item-size').textContent)
  check('file: cancel offered while in flight', el.querySelector('.file-cancel') !== null)
  check('file: cancel is a danger button',
    el.querySelector('.file-cancel').className === 'btn btn-danger btn-sm file-cancel',
    el.querySelector('.file-cancel').className)

  await tick(30)
  await el.updateComplete

  check('file: uploaded through the protocol',
    eq(win.__requests.map((r) => r.method), ['uploadInit', 'uploadEnd']),
    win.__requests.map((r) => r.method))
  check('file: row marked done',
    el.querySelector('.file-item').className === 'file-item done',
    el.querySelector('.file-item').className)
  check('file: batch controls gone', el.querySelector('.file-batch') === null)
  check('file: no longer busy', el.hasAttribute('aria-busy') === false)
  check('file: picker re-enabled', input.disabled === false)
  check('file: completion announced',
    el.querySelector('[aria-live]').textContent.trim() === 'a.csv uploaded',
    el.querySelector('[aria-live]').textContent)
  check('file: no value ever reported', events.length === 0, events)

  // An init rejection (the oversize path) surfaces in the alert region.
  win.__requestPlan = () => ({ error: 'Maximum upload size exceeded' })
  el.upload([file('big.csv', 20)])
  await tick(30)
  await el.updateComplete

  check('file: error rendered',
    el.querySelector('.file-errors').textContent.trim() === 'Maximum upload size exceeded',
    el.querySelector('.file-errors').textContent)
  check('file: error row marked',
    el.querySelector('.file-item').className === 'file-item error',
    el.querySelector('.file-item').className)
  win.__requestPlan = null

  // Cancelling mid-batch abandons it: no uploadEnd, so the server never
  // sets the value.
  win.__requests = []
  win.__postPlan = () => ({ defer: true })
  el.upload([file('slow.csv', 10)])
  await tick(30)
  await el.updateComplete

  el.querySelector('.file-cancel').click()
  await tick(20)
  await el.updateComplete

  check('file: cancel skipped uploadEnd',
    eq(win.__requests.map((r) => r.method), ['uploadInit']),
    win.__requests.map((r) => r.method))
  check('file: cancel announced',
    el.querySelector('[aria-live]').textContent.trim() === 'Upload cancelled')
  win.__postPlan = null

  // One bar, not two: a single file's own progress is the batch progress,
  // so only the batch bar renders. Several files each get their own.
  win.__postPlan = () => ({ defer: true })
  el.upload([file('solo.csv', 10, 'text/csv')])
  await tick(20)
  await el.updateComplete
  check('file: single file has no per-file bar',
    el.querySelectorAll('.file-item-progress').length === 0,
    el.querySelectorAll('.file-item-progress').length)
  // The list sits in an always-available disclosure, open by default,
  // with a count-and-size summary line.
  check('file: list wrapped in an open disclosure',
    el.querySelector('.file-disclosure') !== null &&
      el.querySelector('.file-disclosure').hasAttribute('open'))
  check('file: summary counts one file',
    el.querySelector('.file-summary').textContent.replace(/\s+/g, ' ').trim() === '1 file · 10 B',
    el.querySelector('.file-summary').textContent)

  // A user's fold survives re-renders: sync runs through the toggle
  // handler, and progress updates must not reopen the list.
  el.querySelector('.file-disclosure').open = false
  el.querySelector('.file-disclosure').dispatchEvent(new win.Event('toggle'))
  await el.updateComplete
  win.__deferredPosts[0].upload.onprogress({ lengthComputable: true, loaded: 5 })
  await el.updateComplete
  check('file: fold survives a progress re-render',
    el.querySelector('.file-disclosure').hasAttribute('open') === false)

  // The batch row (bar + cancel) renders above the file list.
  check('file: batch row precedes the list',
    (el.querySelector('.file-batch').compareDocumentPosition(
      el.querySelector('.file-list')) & win.Node.DOCUMENT_POSITION_FOLLOWING) !== 0)
  check('file: single file still has a batch bar',
    el.querySelectorAll('.file-batch-progress').length === 1)
  el.querySelector('.file-cancel').click()
  await el.updateComplete

  el.upload([file('a.csv', 10, 'text/csv'), file('b.csv', 10, 'text/csv')])
  await tick(20)
  await el.updateComplete
  check('file: several files each get a bar',
    el.querySelectorAll('.file-item-progress').length === 2,
    el.querySelectorAll('.file-item-progress').length)
  check('file: several files still get a batch bar',
    el.querySelectorAll('.file-batch-progress').length === 1)
  check('file: summary counts several files',
    el.querySelector('.file-summary').textContent.replace(/\s+/g, ' ').trim() === '2 files · 20 B',
    el.querySelector('.file-summary').textContent)
  check('file: a new batch reopens the fold',
    el.querySelector('.file-disclosure').hasAttribute('open'))

  // The summary line is a template; state tokens fill from the live
  // batch (two files staged, none done, no progress yet).
  const summaryText = () =>
    el.querySelector('.file-summary').textContent.replace(/\s+/g, ' ').trim()
  binding.receiveMessage(el, { summary: '{done}/{n} uploaded · {percent}%' })
  await el.updateComplete
  check('file: summary template with state tokens',
    summaryText() === '0/2 uploaded · 0%', summaryText())
  binding.receiveMessage(el, { summary: '{files} {wat}' })
  await el.updateComplete
  check('file: unknown summary token renders verbatim',
    summaryText() === '2 files {wat}', summaryText())
  binding.receiveMessage(el, { summary: '{files} · {size}' })
  await el.updateComplete
  el.querySelector('.file-cancel').click()
  await el.updateComplete
  win.__postPlan = null

  // update_file() messages.
  binding.receiveMessage(el, { accept: '.txt', placeholder: 'Drop a text file' })
  await el.updateComplete
  check('file: accept updated', input.getAttribute('accept') === '.txt', input.getAttribute('accept'))
  check('file: placeholder updated',
    el.querySelector('.file-prompt').textContent === 'Drop a text file',
    el.querySelector('.file-prompt').textContent)

  binding.receiveMessage(el, { disable: true })
  await el.updateComplete
  check('file: disabled', input.disabled === true && el.hasAttribute('disabled'))

  binding.receiveMessage(el, { enable: true })
  await el.updateComplete
  check('file: enabled', input.disabled === false && el.hasAttribute('disabled') === false)

  binding.receiveMessage(el, { reset: true })
  await el.updateComplete
  check('file: reset clears the list', el.querySelector('.file-list') === null)
  check('file: reset clears the error',
    el.querySelector('.file-error') === null,
    el.querySelector('.file-errors').textContent)

  // Restore the fixture's accept for the drop cases below.
  binding.receiveMessage(el, { accept: '.csv,text/csv' })
  await el.updateComplete

  // ---- drop, paste, pre-validation ----
  //
  // jsdom has no DragEvent and no DataTransfer, so drops carry a minimal
  // stand-in: the items list (with webkitGetAsEntry for folder detection)
  // the component actually reads.
  const transfer = (entries) => ({
    dropEffect: '',
    files: entries.filter((e) => !e.directory).map((e) => e.file),
    items: entries.map((e) => ({
      kind: 'file',
      getAsFile: () => e.file ?? null,
      webkitGetAsEntry: () =>
        e.directory ? { isDirectory: true, name: e.name } : { isDirectory: false }
    }))
  })

  const fire = (type, prop, value) => {
    const event = new win.Event(type, { bubbles: true, cancelable: true })
    if (prop) Object.defineProperty(event, prop, { value })
    el.querySelector('.file-dropzone').dispatchEvent(event)
    return event
  }

  const errorText = () =>
    [...el.querySelectorAll('.file-error')].map((n) => n.textContent)

  const dropzone = () => el.querySelector('.file-dropzone')

  // Drag-over state is entry-counted, so crossing a child does not clear it.
  fire('dragenter', 'dataTransfer', transfer([]))
  await el.updateComplete
  check('file: dragover state on', dropzone().classList.contains('dragover'))
  fire('dragenter', 'dataTransfer', transfer([]))
  fire('dragleave')
  await el.updateComplete
  check('file: dragover survives a child leave', dropzone().classList.contains('dragover'))
  fire('dragleave')
  await el.updateComplete
  check('file: dragover state off', dropzone().classList.contains('dragover') === false)

  // dragover must be cancelled or the browser navigates to the file.
  const dragover = fire('dragover', 'dataTransfer', transfer([]))
  check('file: dragover is cancelled', dragover.defaultPrevented === true)

  // A dropped file goes through the same path as a picked one.
  win.__requests = []
  win.__postPlan = null
  fire('drop', 'dataTransfer', transfer([{ file: file('dropped.csv', 8, 'text/csv') }]))
  await tick(30)
  await el.updateComplete
  check('file: dropped file uploaded',
    eq(win.__requests.map((r) => r.method), ['uploadInit', 'uploadEnd']),
    win.__requests.map((r) => r.method))
  check('file: dropped file listed',
    el.querySelector('.file-item-name').textContent === 'dropped.csv')

  // Drops bypass the picker's accept filtering, so the component redoes it.
  win.__requests = []
  fire('drop', 'dataTransfer', transfer([{ file: file('notes.txt', 8, 'text/plain') }]))
  await tick(20)
  await el.updateComplete
  check('file: accept mismatch rejected',
    eq(errorText(), ['notes.txt is not an accepted file type.']), errorText())
  check('file: accept mismatch never uploads', win.__requests.length === 0, win.__requests)

  // Oversize files fail here rather than costing a round trip.
  el.maxSize = 10
  fire('drop', 'dataTransfer', transfer([{ file: file('huge.csv', 12, 'text/csv') }]))
  await tick(20)
  await el.updateComplete
  check('file: oversize rejected with the limit',
    eq(errorText(), ['huge.csv is larger than the 10 B upload limit.']), errorText())
  el.maxSize = 5242880

  // A folder drops as a File that would fail opaquely mid-POST.
  fire('drop', 'dataTransfer', transfer([{ directory: true, name: 'reports' }]))
  await tick(20)
  await el.updateComplete
  check('file: folder rejected',
    eq(errorText(), ['reports is a folder, and folders cannot be uploaded.']), errorText())

  // Pasted files (screenshots) take the same route as drops.
  win.__requests = []
  fire('paste', 'clipboardData', { files: [file('pasted.csv', 6, 'text/csv')] })
  await tick(30)
  await el.updateComplete
  check('file: pasted file uploaded',
    eq(win.__requests.map((r) => r.method), ['uploadInit', 'uploadEnd']),
    win.__requests.map((r) => r.method))

  // A single-file input given several: reject rather than silently keep one.
  el.multiple = false
  await el.updateComplete
  win.__requests = []
  fire('drop', 'dataTransfer', transfer([
    { file: file('a.csv', 4, 'text/csv') },
    { file: file('b.csv', 4, 'text/csv') }
  ]))
  await tick(20)
  await el.updateComplete
  check('file: multi-file drop on a single-file input rejected',
    eq(errorText(), ['Only one file may be uploaded.']), errorText())
  check('file: rejected batch never uploads', win.__requests.length === 0, win.__requests)
  el.multiple = true

  // Disabled inputs ignore drops entirely.
  binding.receiveMessage(el, { disable: true })
  await el.updateComplete
  win.__requests = []
  fire('drop', 'dataTransfer', transfer([{ file: file('late.csv', 4, 'text/csv') }]))
  await tick(20)
  check('file: disabled ignores drops', win.__requests.length === 0, win.__requests)
  binding.receiveMessage(el, { enable: true })
  await el.updateComplete
}

// ---- file, manual mode ----
{
  const { binding, els } = bind('bsides.file')
  const el = doc.getElementById('uplm')

  win.__connected = true
  win.__requests = []
  win.__posts = []
  win.__requestPlan = null
  win.__postPlan = null
  win.__deferredPosts = []
  win.__deferredRequests = []

  const file = (name, bytes, type = '') =>
    new win.File(['x'.repeat(bytes)], name, { type })
  const names = () =>
    [...el.querySelectorAll('.file-item-name')].map((n) => n.textContent)
  const removes = () => el.querySelectorAll('.file-item-remove')
  const live = () => el.querySelector('[aria-live]').textContent.trim()
  const uploadButton = () => el.querySelector('.file-upload')

  check('manual: found', els.includes(el))
  check('manual: mode from attribute', el.mode === 'manual')

  // The batch row is permanent in manual mode: the disabled Upload
  // button is the affordance that a second action is coming.
  check('manual: batch row at rest', uploadButton() !== null)
  check('manual: upload disabled at zero staged',
    uploadButton().disabled === true)

  // Staging fires no requests — the selection is not yet the value.
  el.upload([file('a.csv', 10, 'text/csv')])
  await tick(20)
  await el.updateComplete
  check('manual: staging fires no requests',
    win.__requests.length === 0, win.__requests)
  check('manual: staged row is pending',
    el.querySelector('.file-item').className === 'file-item pending',
    el.querySelector('.file-item').className)
  check('manual: upload enabled once staged',
    uploadButton().disabled === false)
  check('manual: staging announced',
    live() === 'a.csv added, 1 file staged', live())

  // Gestures accumulate rather than replace.
  el.upload([file('b.csv', 20, 'text/csv')])
  await el.updateComplete
  check('manual: additions accumulate',
    eq(names(), ['a.csv', 'b.csv']), names())

  // A rejected addition reports, and leaves the set alone.
  el.upload([], [{ name: 'stuff', reason: { kind: 'directory' } }])
  await el.updateComplete
  check('manual: rejection reported',
    el.querySelector('.file-error') !== null)
  check('manual: rejection leaves the set intact',
    eq(names(), ['a.csv', 'b.csv']), names())

  // Same name replaces in place.
  el.upload([file('a.csv', 30, 'text/csv')])
  await el.updateComplete
  check('manual: same name replaces',
    eq(names(), ['a.csv', 'b.csv']), names())
  check('manual: replacement announced',
    live() === 'a.csv replaced, 2 files staged', live())
  check('manual: replacement carries the new size',
    el.querySelector('.file-item-size').textContent === '30 B',
    el.querySelector('.file-item-size').textContent)
  check('manual: replacement leaves focus alone',
    doc.activeElement !== removes()[0], doc.activeElement?.className)

  // Removal: the row goes, focus lands on the replacing row's control.
  check('manual: remove controls render', removes().length === 2)
  removes()[0].click()
  await el.updateComplete
  await tick(0)
  check('manual: row removed', eq(names(), ['b.csv']), names())
  check('manual: removal announced', live() === 'a.csv removed', live())
  check('manual: focus moves to the replacing row',
    doc.activeElement === removes()[0], doc.activeElement?.className)

  // Removing the last row lands on the previous row's control.
  el.upload([file('c.csv', 5, 'text/csv')])
  await el.updateComplete
  removes()[1].click()
  await el.updateComplete
  await tick(0)
  check('manual: last-row removal focuses the previous control',
    doc.activeElement === removes()[0], doc.activeElement?.className)

  // Emptying the list lands on the picker: the Upload button is
  // disabled again and a disabled button takes no focus.
  removes()[0].click()
  await el.updateComplete
  await tick(0)
  check('manual: list gone once emptied',
    el.querySelector('.file-list') === null)
  check('manual: emptied list focuses the picker',
    doc.activeElement === el.querySelector('.file-input'),
    doc.activeElement?.className)
  check('manual: upload disabled again at zero staged',
    uploadButton().disabled === true)

  // select = "one": a new pick replaces the staged file.
  el.multiple = false
  await el.updateComplete
  el.upload([file('one.csv', 5, 'text/csv')])
  el.upload([file('two.csv', 5, 'text/csv')])
  await el.updateComplete
  check('manual: select one keeps a single staged file',
    eq(names(), ['two.csv']), names())
  el.upload([file('one.csv', 5, 'text/csv'), file('two.csv', 5, 'text/csv')])
  await el.updateComplete
  check('manual: select one rejects a multi-file gesture whole',
    eq(names(), ['two.csv']), names())
  el.multiple = true
  await el.updateComplete
  removes()[0].click()
  await el.updateComplete
  await tick(0)

  // The Upload button starts the batch; remove controls hide in flight.
  el.upload([file('x.csv', 10, 'text/csv'), file('y.csv', 10, 'text/csv')])
  await el.updateComplete
  win.__postPlan = () => ({ defer: true })
  uploadButton().click()
  await tick(20)
  await el.updateComplete
  check('manual: upload starts one job per staged file',
    eq(win.__requests.map((r) => r.method), ['uploadInit', 'uploadInit']),
    win.__requests.map((r) => r.method))
  check('manual: remove controls hide in flight', removes().length === 0)
  check('manual: cancel offered in flight',
    el.querySelector('.file-cancel') !== null)

  // Complete the POSTs; they are sequential, so drain until the second
  // (created only once the first lands) has come and gone.
  while (win.__deferredPosts.length > 0) {
    const xhr = win.__deferredPosts.shift()
    xhr.upload.onprogress({ lengthComputable: true, loaded: 10 })
    xhr.status = 200
    xhr.onload()
    await tick(10)
  }
  win.__postPlan = null
  await tick(20)
  await el.updateComplete
  check('manual: batch delivered',
    eq(win.__requests.map((r) => r.method),
      ['uploadInit', 'uploadInit', 'uploadEnd', 'uploadEnd']),
    win.__requests.map((r) => r.method))
  check('manual: rows done',
    [...el.querySelectorAll('.file-item')].every(
      (row) => row.className === 'file-item done'),
    [...el.querySelectorAll('.file-item')].map((row) => row.className))
  // The value itself: one payload carrying the file count, from which R's
  // batch handler rebuilds the slot names the per-file uploadEnd calls
  // filled and rbinds them in position order.
  const batches = () => win.__setInputValues
    .filter((v) => v.name === 'uplm:bsides.file.batch')
    .map((v) => v.value)

  check('manual: one batch payload per delivery', batches().length === 1, batches())
  check('manual: batch payload counts the files and names no slots',
    batches()[0].n === 2 && batches()[0].slots === undefined,
    batches()[0])
  check('manual: batch payload carries a seq', batches()[0].seq === 1, batches()[0])

  check('manual: upload disabled after delivery',
    uploadButton().disabled === true)
  check('manual: done rows are not removable', removes().length === 0)

  // The next addition starts a fresh staged set.
  el.upload([file('z.csv', 5, 'text/csv')])
  await el.updateComplete
  check('manual: addition after delivery starts fresh',
    eq(names(), ['z.csv']), names())

  // ---- cancel: rows return to pending, the retry is a fresh batch ----
  binding.receiveMessage(el, { reset: true })
  await el.updateComplete
  el.upload([file('p.csv', 10, 'text/csv'), file('q.csv', 10, 'text/csv')])
  await el.updateComplete
  win.__requests = []
  win.__posts = []
  win.__postPlan = (call, i) => (i === 1 ? { defer: true } : null)
  uploadButton().click()
  await tick(30)
  await el.updateComplete

  // p.csv completed before the cancel; q.csv is in flight.
  el.querySelector('.file-cancel').click()
  await el.updateComplete
  win.__postPlan = null
  check('manual: cancel returns every row to pending',
    [...el.querySelectorAll('.file-item')].every(
      (row) => row.className === 'file-item pending'),
    [...el.querySelectorAll('.file-item')].map((row) => row.className))
  check('manual: cancel leaves the in-flight file unfinished',
    eq(win.__requests.map((r) => r.method),
      ['uploadInit', 'uploadInit', 'uploadEnd']),
    win.__requests.map((r) => r.method))
  check('manual: cancel finished only the file that landed',
    eq(win.__requests.filter((r) => r.method === 'uploadEnd').map((r) => r.args),
      [['job1', 'uplm__bsides_slot_1']]),
    win.__requests.filter((r) => r.method === 'uploadEnd').map((r) => r.args))
  check('manual: upload button returns after cancel',
    uploadButton() !== null && uploadButton().disabled === false)

  // The retry runs a fresh uploadInit and re-POSTs every file, the one
  // that completed before the cancel included.
  uploadButton().click()
  await tick(30)
  await el.updateComplete
  check('manual: retry issues a fresh job per file',
    eq(win.__requests.map((r) => r.method),
      ['uploadInit', 'uploadInit', 'uploadEnd',
       'uploadInit', 'uploadInit', 'uploadEnd', 'uploadEnd']),
    win.__requests.map((r) => r.method))
  check('manual: retry re-posts every file',
    eq(win.__posts.map((post) => post.name),
      ['p.csv', 'q.csv', 'p.csv', 'q.csv']),
    win.__posts.map((post) => post.name))

  // ---- failure: pending again, the failed row alone keeps the mark ----
  el.upload([file('f.csv', 10, 'text/csv'), file('g.csv', 10, 'text/csv')])
  await el.updateComplete
  check('manual: addition after delivery starts fresh again',
    eq(names(), ['f.csv', 'g.csv']), names())
  win.__requests = []
  win.__posts = []
  win.__postPlan = (call, i) => (i === 1 ? { status: 500 } : null)
  uploadButton().click()
  await tick(30)
  await el.updateComplete
  win.__postPlan = null

  check('manual: failure marks the failed row alone',
    eq([...el.querySelectorAll('.file-item')].map((row) => row.className),
      ['file-item pending', 'file-item error']),
    [...el.querySelectorAll('.file-item')].map((row) => row.className))
  check('manual: failure message rendered',
    el.querySelector('.file-error') !== null)
  check('manual: upload button returns after failure',
    uploadButton() !== null && uploadButton().disabled === false)
  check('manual: failed row is removable', removes().length === 2)

  // An addition after a failure appends — the set delivered nothing —
  // and ends the failure's reporting: the message and the row marks
  // clear together, so no red row outlives its explanation.
  el.upload([file('h.csv', 5, 'text/csv')])
  await el.updateComplete
  check('manual: addition after failure appends',
    eq(names(), ['f.csv', 'g.csv', 'h.csv']), names())
  check('manual: addition after failure clears the row marks',
    [...el.querySelectorAll('.file-item')].every(
      (row) => row.className === 'file-item pending'),
    [...el.querySelectorAll('.file-item')].map((row) => row.className))
  check('manual: addition after failure clears the message',
    el.querySelector('.file-error') === null,
    el.querySelector('.file-errors').textContent)

  // A retry clears the previous attempt's message and resets marks.
  uploadButton().click()
  await tick(30)
  await el.updateComplete
  check('manual: retry clears the failure message',
    el.querySelector('.file-error') === null,
    el.querySelector('.file-errors').textContent)
  check('manual: retry delivers',
    [...el.querySelectorAll('.file-item')].every(
      (row) => row.className === 'file-item done'),
    [...el.querySelectorAll('.file-item')].map((row) => row.className))

  // Any set edit ends the failure's reporting: removing the pending
  // row clears the message and the surviving row's mark alike.
  el.upload([file('i.csv', 10, 'text/csv'), file('j.csv', 10, 'text/csv')])
  await el.updateComplete
  win.__posts = []
  win.__postPlan = (call, i) => (i === 1 ? { status: 500 } : null)
  uploadButton().click()
  await tick(30)
  await el.updateComplete
  win.__postPlan = null
  removes()[0].click()
  await el.updateComplete
  await tick(0)
  check('manual: removing a row clears the message',
    el.querySelector('.file-error') === null,
    el.querySelector('.file-errors').textContent)
  check('manual: removing a row clears the surviving mark',
    el.querySelector('.file-item').className === 'file-item pending',
    el.querySelector('.file-item').className)
  removes()[0].click()
  await el.updateComplete
  await tick(0)

  // ---- the action triggers, over the message path ----
  const postsBefore = win.__posts.length
  binding.receiveMessage(el, { upload_start: true })
  await tick(20)
  check('manual: upload_start no-ops on an empty set',
    win.__posts.length === postsBefore, win.__posts.length - postsBefore)

  el.upload([file('m.csv', 10, 'text/csv')])
  await el.updateComplete
  binding.receiveMessage(el, { upload_cancel: true })
  await el.updateComplete
  check('manual: upload_cancel no-ops with nothing in flight',
    el.querySelector('.file-item').className === 'file-item pending')

  win.__requests = []
  binding.receiveMessage(el, { upload_start: true })
  await tick(30)
  await el.updateComplete
  check('manual: upload_start starts the staged batch',
    eq(win.__requests.map((r) => r.method), ['uploadInit', 'uploadEnd']),
    win.__requests.map((r) => r.method))

  win.__postPlan = () => ({ defer: true })
  el.upload([file('n.csv', 10, 'text/csv')])
  await el.updateComplete
  binding.receiveMessage(el, { upload_start: true })
  await tick(20)
  await el.updateComplete
  binding.receiveMessage(el, { upload_cancel: true })
  await el.updateComplete
  win.__postPlan = null
  check('manual: upload_cancel abandons the flight',
    el.querySelector('.file-item').className === 'file-item pending',
    el.querySelector('.file-item').className)
  binding.receiveMessage(el, { reset: true })
  await el.updateComplete

  // The same set uploaded twice in a row delivers twice: the payloads are
  // identical but for `seq`, which is what keeps Shiny's client from
  // dropping the second send as a repeat of the first.
  const twice = []
  for (const round of [1, 2]) {
    const before = win.__setInputValues.length
    el.upload([file('same.csv', 10, 'text/csv')])
    await el.updateComplete
    uploadButton().click()
    await tick(30)
    await el.updateComplete
    twice.push(...win.__setInputValues
      .slice(before)
      .filter((v) => v.name === 'uplm:bsides.file.batch')
      .map((v) => v.value))
    check(`manual: identical batch ${round} delivered`, twice.length === round, twice)
    binding.receiveMessage(el, { reset: true })
    await el.updateComplete
  }

  check('manual: identical batches send the same count',
    twice[0].n === twice[1].n && twice[0].n === 1, twice.map((b) => b.n))
  check('manual: identical batches are distinguished by seq',
    twice[1].seq === twice[0].seq + 1, twice.map((b) => b.seq))

  // A batch that dies delivers nothing: no payload, so R's handler never
  // runs and input$<id> keeps whatever it last held.
  for (const [label, kill] of [
    ['failure', async () => {
      win.__postPlan = () => ({ status: 500 })
      uploadButton().click()
      await tick(30)
      win.__postPlan = null
    }],
    ['cancel', async () => {
      win.__postPlan = () => ({ defer: true })
      uploadButton().click()
      await tick(20)
      await el.updateComplete
      el.querySelector('.file-cancel').click()
      await tick(20)
      win.__postPlan = null
    }]
  ]) {
    binding.receiveMessage(el, { reset: true })
    await el.updateComplete
    el.upload([file('doomed.csv', 10, 'text/csv'), file('other.csv', 10, 'text/csv')])
    await el.updateComplete

    const before = win.__setInputValues.length
    await kill()
    await el.updateComplete

    check(`manual: ${label} sends no batch payload`,
      win.__setInputValues.slice(before)
        .every((v) => v.name !== 'uplm:bsides.file.batch'),
      win.__setInputValues.slice(before).map((v) => v.name))
  }

  binding.receiveMessage(el, { reset: true })
  await el.updateComplete

  // upload_start is a manual-mode concept: the auto input ignores it.
  const auto = doc.getElementById('upl')
  binding.receiveMessage(auto, { reset: true })
  await auto.updateComplete
  win.__requests = []
  binding.receiveMessage(auto, { upload_start: true })
  await tick(20)
  check('manual: upload_start no-ops in auto mode',
    win.__requests.length === 0, win.__requests)
}

// ---- file, upload cap ----
{
  const binding = registered['bsides.file']
  const el = doc.getElementById('uplm')

  win.__connected = true
  win.__requests = []
  win.__posts = []
  win.__requestPlan = null
  win.__postPlan = null
  win.__deferredPosts = []
  win.__deferredRequests = []

  const file = (name, bytes, type = '') =>
    new win.File(['x'.repeat(bytes)], name, { type })
  const names = () =>
    [...el.querySelectorAll('.file-item-name')].map((n) => n.textContent)
  const picker = () => el.querySelector('.file-input')
  const dropzone = () => el.querySelector('.file-dropzone')
  const prompt = () => el.querySelector('.file-prompt').textContent
  const errorText = () =>
    [...el.querySelectorAll('.file-error')].map((n) => n.textContent)

  binding.receiveMessage(el, { reset: true })
  await el.updateComplete
  el.max = 2
  await el.updateComplete

  el.upload([file('a.csv', 4, 'text/csv')])
  await el.updateComplete
  check('cap: below the cap the picker is live', picker().disabled === false)

  // A gesture past the cap is rejected whole — quietly keeping a prefix
  // of it would read as data loss.
  el.upload([file('b.csv', 4, 'text/csv'), file('c.csv', 4, 'text/csv')])
  await el.updateComplete
  check('cap: an overfilling gesture is rejected whole',
    eq(names(), ['a.csv']), names())
  check('cap: the rejection is readable',
    eq(errorText(), ['At most 2 files may be uploaded.']), errorText())

  // At the cap the input stops accepting — prevention, with the prompt
  // carrying the reason.
  el.upload([file('b.csv', 4, 'text/csv')])
  await el.updateComplete
  check('cap: a full set disables the picker', picker().disabled === true)
  check('cap: a full set marks the dropzone',
    dropzone().classList.contains('at-max'))
  check('cap: the prompt says why',
    prompt() === 'Limit of 2 files reached — remove one to add more',
    prompt())

  // Drops bypass the picker, and a same-named drop replaces rather than
  // adds, so it passes at the cap.
  el.upload([file('b.csv', 9, 'text/csv')])
  await el.updateComplete
  check('cap: same-name replacement passes at the cap',
    eq(names(), ['a.csv', 'b.csv']), names())
  check('cap: replacement carries the new size',
    [...el.querySelectorAll('.file-item-size')].at(-1).textContent === '9 B',
    [...el.querySelectorAll('.file-item-size')].map((n) => n.textContent))

  // Removal reopens the input.
  el.querySelector('.file-item-remove').click()
  await el.updateComplete
  await tick(0)
  check('cap: removal reopens the picker', picker().disabled === false)
  check('cap: removal restores the prompt',
    prompt() !== 'Limit of 2 files reached — remove one to add more',
    prompt())

  // Done rows do not count: a delivered batch is not part of the next
  // one, so a full delivered set does not trap the input.
  el.upload([file('d.csv', 4, 'text/csv')])
  await el.updateComplete
  el.querySelector('.file-upload').click()
  await tick(30)
  await el.updateComplete
  check('cap: delivered rows do not count', picker().disabled === false,
    [...el.querySelectorAll('.file-item')].map((row) => row.className))

  // Auto mode has no accumulating set; its cap bounds the gesture.
  const auto = doc.getElementById('upl')
  auto.max = 2
  await auto.updateComplete
  win.__requests = []
  auto.upload([
    file('x.csv', 4, 'text/csv'),
    file('y.csv', 4, 'text/csv'),
    file('z.csv', 4, 'text/csv'),
  ])
  await tick(20)
  await auto.updateComplete
  check('cap: auto mode rejects an oversized gesture whole',
    win.__requests.length === 0, win.__requests)
  auto.max = null
  await auto.updateComplete

  binding.receiveMessage(el, { reset: true })
  el.max = null
  await el.updateComplete
}

// ---- file, hidden upload button ----
{
  const binding = registered['bsides.file']
  const el = doc.getElementById('uplm')

  win.__connected = true
  win.__requests = []
  win.__posts = []
  win.__requestPlan = null
  win.__postPlan = null
  win.__deferredPosts = []
  win.__deferredRequests = []

  const file = (name, bytes, type = '') =>
    new win.File(['x'.repeat(bytes)], name, { type })

  binding.receiveMessage(el, { reset: true })
  await el.updateComplete
  el.button = 'none'
  await el.updateComplete

  // At rest the batch row held only the Upload button, so nothing
  // renders; the start paths are untouched.
  check('button: no upload button at rest',
    el.querySelector('.file-upload') === null)
  check('button: no batch row at rest',
    el.querySelector('.file-batch') === null)

  el.upload([file('a.csv', 10, 'text/csv')])
  await el.updateComplete
  check('button: staging renders no button either',
    el.querySelector('.file-upload') === null)

  // In flight the row returns whole — a batch the user cannot cancel
  // would be a regression, not a simplification.
  win.__postPlan = () => ({ defer: true })
  binding.receiveMessage(el, { upload_start: true })
  await tick(20)
  await el.updateComplete
  check('button: upload_start still starts the batch',
    win.__requests.map((r) => r.method).includes('uploadInit'),
    win.__requests.map((r) => r.method))
  check('button: cancel still renders in flight',
    el.querySelector('.file-cancel') !== null)

  el.querySelector('.file-cancel').click()
  await el.updateComplete
  win.__postPlan = null
  win.__deferredPosts.length = 0

  binding.receiveMessage(el, { reset: true })
  el.button = 'show'
  await el.updateComplete
  check('button: show restores the button',
    el.querySelector('.file-upload') !== null)
}

// ---- file, state companions ----
{
  const { binding } = { binding: registered['bsides.file'] }
  const el = doc.getElementById('uplm')

  win.__connected = true
  win.__requests = []
  win.__posts = []
  win.__requestPlan = null
  win.__postPlan = null
  win.__deferredPosts = []
  win.__deferredRequests = []

  const file = (name, bytes, type = '') =>
    new win.File(['x'.repeat(bytes)], name, { type })

  // A recorder for Shiny.setInputValue, which the component pushes its
  // __bsides_* companions through.
  const inputs = []
  win.Shiny.setInputValue = (name, value) => inputs.push({ name, value })
  // The staged companion's name carries its input-handler type suffix
  // (`:bsides.file.staged`), so match on the name's head.
  const named = (suffix) =>
    inputs.filter((i) => i.name.split(':')[0] === `uplm__bsides_${suffix}`)
  const last = (suffix) => named(suffix).at(-1)?.value
  const count = (suffix) => named(suffix).length

  binding.receiveMessage(el, { reset: true })
  await el.updateComplete
  check('state: idle after reset', last('status') === 'idle', last('status'))
  check('state: staged empty at idle', eq(last('staged'), []), last('staged'))
  check('state: no error at idle', last('error') === null)

  // A rejection feeds the error companion structured records — kind,
  // the rendered sentences, one row per file — and leaves the status
  // alone: nothing was attempted.
  el.upload([], [{ name: 'stuff', reason: { kind: 'directory' } }])
  await el.updateComplete
  check('state: rejection pushes a record',
    eq(last('error'), {
      kind: 'rejection',
      messages: ['stuff is a folder, and folders cannot be uploaded.'],
      files: [{ name: 'stuff', reason: 'directory', limit: null }],
    }),
    last('error'))
  check('state: rejection leaves status alone',
    last('status') === 'idle', last('status'))

  // A reason with a limit carries it into the record.
  el.maxSize = 5
  el.upload([file('big.csv', 10, 'text/csv')])
  await el.updateComplete
  check('state: size rejection carries the limit',
    eq(last('error').files, [{ name: 'big.csv', reason: 'size', limit: 5 }]),
    last('error'))
  el.maxSize = null

  // A gesture-level rejection is recorded against every file in the
  // gesture, under one sentence.
  el.multiple = false
  await el.updateComplete
  el.upload([file('x.csv', 4, 'text/csv'), file('y.csv', 4, 'text/csv')])
  await el.updateComplete
  check('state: gesture-level rejection records every file',
    eq(last('error').files.map((f) => f.name), ['x.csv', 'y.csv']) &&
      last('error').messages.length === 1,
    last('error'))
  el.multiple = true
  await el.updateComplete

  // One two-file gesture pushes the staged set once, whole.
  const stagedBefore = count('staged')
  el.upload([file('a.csv', 10, 'text/csv'), file('b.csv', 20, 'text/csv')])
  await el.updateComplete
  check('state: staged status once staged',
    last('status') === 'staged', last('status'))
  check('state: staged payload carries the set',
    eq(last('staged'), [
      { name: 'a.csv', size: 10, type: 'text/csv' },
      { name: 'b.csv', size: 20, type: 'text/csv' },
    ]),
    last('staged'))
  check('state: one gesture pushes the set once',
    count('staged') === stagedBefore + 1,
    count('staged') - stagedBefore)
  check('state: a set edit clears the error', last('error') === null)

  // A removal is a set edit.
  el.querySelector('.file-item-remove').click()
  await el.updateComplete
  await tick(0)
  check('state: removal updates the staged payload',
    eq(last('staged'), [{ name: 'b.csv', size: 20, type: 'text/csv' }]),
    last('staged'))

  // Flight: uploading, throttled progress, the final 1, then done.
  win.__postPlan = () => ({ defer: true })
  el.querySelector('.file-upload').click()
  await tick(20)
  await el.updateComplete
  check('state: uploading in flight', last('status') === 'uploading')
  check('state: staged empties in flight', eq(last('staged'), []))

  win.__deferredPosts[0].upload.onprogress({
    lengthComputable: true, loaded: 10,
  })
  await tick(200)
  check('state: progress pushed after the throttle window',
    last('progress') === 0.5, last('progress'))

  const xhr = win.__deferredPosts.shift()
  xhr.upload.onprogress({ lengthComputable: true, loaded: 20 })
  xhr.status = 200
  xhr.onload()
  win.__postPlan = null
  await tick(30)
  await el.updateComplete
  check('state: done after delivery', last('status') === 'done')
  check('state: final progress is 1', last('progress') === 1)

  // Cancel in manual mode is staged again, progress folded back to 0.
  el.upload([file('c.csv', 10, 'text/csv')])
  await el.updateComplete
  win.__postPlan = () => ({ defer: true })
  el.querySelector('.file-upload').click()
  await tick(20)
  await el.updateComplete
  el.querySelector('.file-cancel').click()
  await el.updateComplete
  win.__postPlan = null
  win.__deferredPosts.length = 0
  check('state: cancel lands back in staged',
    last('status') === 'staged', last('status'))
  check('state: cancel zeroes progress', last('progress') === 0)
  check('state: cancel is not a failure', last('error') === null)

  // Failure: status failed, the message pushed; a retry clears it.
  win.__postPlan = () => ({ status: 500 })
  el.querySelector('.file-upload').click()
  await tick(30)
  await el.updateComplete
  win.__postPlan = null
  check('state: failure reported', last('status') === 'failed')
  check('state: failure record pushed',
    last('error') !== null &&
      last('error').kind === 'failure' &&
      last('error').messages.length === 1 &&
      eq(last('error').files, []),
    last('error'))

  // A set edit after a failure is "staged", not "failed" — the marks
  // clear with the message.
  el.upload([file('d.csv', 10, 'text/csv')])
  await el.updateComplete
  check('state: edit after failure lands in staged',
    last('status') === 'staged', last('status'))
  check('state: edit after failure clears the error',
    last('error') === null)

  el.querySelector('.file-upload').click()
  await tick(30)
  await el.updateComplete
  check('state: retry delivers and clears the error',
    last('status') === 'done' && last('error') === null,
    [last('status'), last('error')])

  binding.receiveMessage(el, { reset: true })
  await el.updateComplete
  delete win.Shiny.setInputValue
}

// ---- form + staged file: the batch starts on submit ----
{
  // Both bindings were subscribed by their own sections' bind() calls,
  // #frmf included — find() sweeps the whole document. Re-binding here
  // would double the form's click handler, so reach for the registry.
  const formBinding = registered['bsides.form']
  const binding = registered['bsides.file']
  const form = doc.getElementById('frmf')
  const el = doc.getElementById('frmupl')
  const submit = form.querySelector('.bsides-input-form-submit')

  win.__connected = true
  win.__requests = []
  win.__posts = []
  win.__requestPlan = null
  win.__postPlan = null
  win.__deferredPosts = []
  win.__deferredRequests = []

  const file = (name, bytes, type = '') =>
    new win.File(['x'.repeat(bytes)], name, { type })

  // The submit is observable: the form dispatches bsides-form:submit
  // after replaying the frozen values.
  let submits = 0
  form.addEventListener('bsides-form:submit', () => submits++)

  // Submitting with nothing staged starts nothing.
  submit.click()
  await tick(20)
  check('form-file: submit dispatches bsides-form:submit', submits === 1)
  check('form-file: empty set submits no batch',
    win.__requests.length === 0, win.__requests)

  // A staged set uploads when the form submits.
  el.upload([file('a.csv', 10, 'text/csv'), file('b.csv', 10, 'text/csv')])
  await el.updateComplete
  check('form-file: staging inside a form fires no requests',
    win.__requests.length === 0, win.__requests)

  submit.click()
  await tick(30)
  await el.updateComplete
  check('form-file: submit starts the staged batch',
    eq(win.__requests.map((r) => r.method),
      ['uploadInit', 'uploadInit', 'uploadEnd', 'uploadEnd']),
    win.__requests.map((r) => r.method))
  check('form-file: rows done after the submit-started batch',
    [...el.querySelectorAll('.file-item')].every(
      (row) => row.className === 'file-item done'),
    [...el.querySelectorAll('.file-item')].map((row) => row.className))

  // The server-driven submit runs through the same handler.
  el.upload([file('c.csv', 10, 'text/csv')])
  await el.updateComplete
  win.__requests = []
  formBinding.receiveMessage(form, { submit: 'send' })
  await tick(30)
  await el.updateComplete
  check('form-file: receiveMessage submit also starts the batch',
    eq(win.__requests.map((r) => r.method), ['uploadInit', 'uploadEnd']),
    win.__requests.map((r) => r.method))

  // ---- the form waits for the upload before sending its value ----
  //
  // formValues is only set once a submit actually goes through, so the
  // binding's value is a clean proxy for "has the form sent yet". The
  // Draft button distinguishes these submits from the Send ones above.
  const draft = form.querySelector('.bsides-input-form-submit[value="draft"]')
  const formValue = () => formBinding.getValue(form)

  el.upload([file('d.csv', 10, 'text/csv')])
  await el.updateComplete
  win.__requests = []
  win.__postPlan = () => ({ defer: true })
  draft.click()
  await tick(30)

  check('form-file: upload started, form value withheld',
    eq(win.__requests.map((r) => r.method), ['uploadInit']) &&
      formValue() === 'send',
    [win.__requests.map((r) => r.method), formValue()])
  check('form-file: clicked submit is pending',
    draft.classList.contains('pending') &&
      draft.getAttribute('aria-busy') === 'true')
  check('form-file: every submit disabled while pending',
    draft.disabled === true && submit.disabled === true)

  while (win.__deferredPosts.length > 0) {
    const xhr = win.__deferredPosts.shift()
    xhr.status = 200
    xhr.onload()
    await tick(10)
  }
  win.__postPlan = null
  await tick(30)
  await el.updateComplete

  check('form-file: form value sent only after uploadEnd',
    eq(win.__requests.map((r) => r.method), ['uploadInit', 'uploadEnd']) &&
      formValue() === 'draft',
    [win.__requests.map((r) => r.method), formValue()])
  check('form-file: pending cleared, submits re-enabled',
    draft.classList.contains('pending') === false &&
      draft.hasAttribute('aria-busy') === false &&
      draft.disabled === false && submit.disabled === false)

  // ---- a submit arriving mid-flight waits for the running batch ----
  el.upload([file('e.csv', 10, 'text/csv')])
  await el.updateComplete
  win.__requests = []
  win.__postPlan = () => ({ defer: true })
  el.querySelector('.file-upload').click()
  await tick(20)
  await el.updateComplete

  submit.click()
  await tick(20)
  check('form-file: mid-flight submit does not restart the batch',
    eq(win.__requests.map((r) => r.method), ['uploadInit']),
    win.__requests.map((r) => r.method))
  check('form-file: mid-flight submit withholds the form value',
    formValue() === 'draft', formValue())
  check('form-file: mid-flight submit shows pending',
    submit.classList.contains('pending'))

  while (win.__deferredPosts.length > 0) {
    const xhr = win.__deferredPosts.shift()
    xhr.status = 200
    xhr.onload()
    await tick(10)
  }
  win.__postPlan = null
  await tick(30)
  await el.updateComplete
  check('form-file: mid-flight submit sends once the batch lands',
    formValue() === 'send', formValue())

  // ---- a failed upload abandons the submit ----
  el.upload([file('f.csv', 10, 'text/csv')])
  await el.updateComplete
  win.__postPlan = () => ({ status: 500 })
  draft.click()
  await tick(40)
  await el.updateComplete
  win.__postPlan = null

  check('form-file: failed upload leaves the form unsubmitted',
    formValue() === 'send', formValue())
  check('form-file: failed upload clears the pending state',
    draft.classList.contains('pending') === false && draft.disabled === false)
  check('form-file: failed upload keeps the set staged for a retry',
    el.querySelectorAll('.file-item').length === 1)

  // ---- a cancel during a form-started upload abandons it too ----
  win.__postPlan = () => ({ defer: true })
  draft.click()
  await tick(20)
  await el.updateComplete
  el.querySelector('.file-cancel').click()
  await tick(20)
  await el.updateComplete
  win.__postPlan = null
  win.__deferredPosts.length = 0

  check('form-file: cancelled upload leaves the form unsubmitted',
    formValue() === 'send', formValue())
  check('form-file: cancelled upload clears the pending state',
    draft.classList.contains('pending') === false && draft.disabled === false)

  binding.receiveMessage(el, { reset: true })
  await el.updateComplete

  // ---- a form with no blockers submits synchronously ----
  //
  // No await between the click and the check: the common case must not
  // defer a microtask just because one form in the package needs to.
  const plainForm = doc.getElementById('frm')
  const plainSubmit = plainForm.querySelector('.bsides-input-form-submit')
  plainSubmit.click()
  check('form-file: a form without blockers submits synchronously',
    formBinding.getValue(plainForm) === 'go',
    formBinding.getValue(plainForm))
}

// ---- file validation (pure functions) ----
{
  const { isAccepted, validateFiles } = win.__validate
  const file = (name, bytes, type = '') =>
    new win.File(['x'.repeat(bytes)], name, { type })

  check('accept: empty accepts anything', isAccepted(file('a.bin', 1), '') === true)
  check('accept: extension token', isAccepted(file('a.CSV', 1), '.csv') === true)
  check('accept: extension token mismatch', isAccepted(file('a.txt', 1), '.csv') === false)
  check('accept: exact mime', isAccepted(file('a', 1, 'text/csv'), 'text/csv') === true)
  check('accept: mime wildcard',
    isAccepted(file('a.png', 1, 'image/png'), 'image/*') === true)
  check('accept: mime wildcard mismatch',
    isAccepted(file('a.txt', 1, 'text/plain'), 'image/*') === false)
  check('accept: any token may match',
    isAccepted(file('a.tsv', 1), '.csv, .tsv') === true)
  // File.type is extension-sniffed and often blank (.parquet, .rds);
  // nothing MIME-shaped can match, so an extension token has to carry it.
  check('accept: blank type falls back to the extension',
    isAccepted(file('a.parquet', 1, ''), '.parquet') === true)
  check('accept: blank type cannot match a mime token',
    isAccepted(file('a.parquet', 1, ''), 'application/octet-stream') === false)

  const result = validateFiles(
    [file('ok.csv', 10, 'text/csv'), file('big.csv', 50, 'text/csv'), file('n.txt', 1)],
    { accept: '.csv', maxSize: 20 }
  )
  check('validate: keeps what passes',
    eq(result.accepted.map((f) => f.name), ['ok.csv']),
    result.accepted.map((f) => f.name))
  check('validate: reports why each file was dropped',
    eq(result.rejected, [
      { name: 'big.csv', reason: { kind: 'size', limit: 20 } },
      { name: 'n.txt', reason: { kind: 'accept' } }
    ]), result.rejected)

  check('validate: no limit means no size check',
    validateFiles([file('big.csv', 50, 'text/csv')], { accept: '', maxSize: null })
      .accepted.length === 1)
}

// ---- uploader (protocol module, no DOM) ----
{
  const { Uploader, UPLOAD_CONCURRENCY } = win.__upload

  const file = (name, bytes, type = '') =>
    new win.File(['x'.repeat(bytes)], name, { type })

  // Fresh recorders and default plans for each scenario.
  const reset = () => {
    win.__connected = true
    win.__requests = []
    win.__posts = []
    win.__requestPlan = null
    win.__postPlan = null
    win.__deferredPosts = []
    win.__deferredRequests = []

    const events = { progress: [], done: [], errors: [], errorFiles: [], finished: 0 }

    return {
      events,
      callbacks: {
        onProgress: ({ file: f, loaded, batch }) =>
          events.progress.push([f && f.name, loaded, batch]),
        onFileDone: (f) => events.done.push(f.name),
        onError: (message, f) => {
          events.errors.push(message)
          events.errorFiles.push(f && f.name)
        },
        onDone: () => { events.finished++ }
      }
    }
  }

  // Happy path: per-file init payloads, overlapping POSTs, progress math,
  // per-file uploadEnd into the position's slot.
  {
    const { events, callbacks } = reset()
    win.__postPlan = (call, i) => (i === 0 ? { progress: [10] } : { progress: [15, 30] })

    await new Uploader({
      inputId: 'upload',
      files: [file('a.csv', 10, 'text/csv'), file('b.csv', 30)],
      ...callbacks
    }).run()

    check('uploader: one init and one end per file',
      eq(win.__requests.map((r) => r.method),
         ['uploadInit', 'uploadInit', 'uploadEnd', 'uploadEnd']),
      win.__requests.map((r) => r.method))
    check('uploader: uploadInit declares one file per job', eq(
      win.__requests.filter((r) => r.method === 'uploadInit').map((r) => r.args),
      [
        [[{ name: 'a.csv', size: 10, type: 'text/csv' }]],
        [[{ name: 'b.csv', size: 30, type: '' }]]
      ]
    ), win.__requests.filter((r) => r.method === 'uploadInit').map((r) => r.args))
    check('uploader: uploadEnd finishes each job into its position slot', eq(
      win.__requests.filter((r) => r.method === 'uploadEnd').map((r) => r.args),
      [
        ['job1', 'upload__bsides_slot_1'],
        ['job2', 'upload__bsides_slot_2']
      ]
    ), win.__requests.filter((r) => r.method === 'uploadEnd').map((r) => r.args))

    check('uploader: one POST per file, in declared order',
      eq(win.__posts.map((p) => p.name), ['a.csv', 'b.csv']), win.__posts.map((p) => p.name))
    check('uploader: each POST goes to its own job url',
      eq(win.__posts.map((p) => p.url),
         ['/session/tok/upload/job1?w=', '/session/tok/upload/job2?w=']),
      win.__posts.map((p) => p.url))
    check('uploader: POSTs are POSTs',
      win.__posts.every((p) => p.method === 'POST'), win.__posts)
    check('uploader: octet-stream content type',
      win.__posts.every((p) => p.headers['Content-Type'] === 'application/octet-stream'),
      win.__posts.map((p) => p.headers))

    // Batch fractions, not per-file: 10 of 40 bytes done when b.csv is at
    // 15, so 25/40.
    const fractions = events.progress.map(([, , batch]) => batch)
    check('uploader: progress starts at 0', fractions[0] === 0, fractions)
    check('uploader: progress is batch-relative',
      fractions.includes(0.25) && fractions.includes(0.625) && fractions.includes(1),
      fractions)
    check('uploader: progress never decreases',
      fractions.every((f, i) => i === 0 || f >= fractions[i - 1]), fractions)
    check('uploader: per-file progress names the file and its bytes',
      events.progress.some(([n, loaded]) => n === 'b.csv' && loaded === 15),
      events.progress)

    check('uploader: each file reported done', eq(events.done, ['a.csv', 'b.csv']), events.done)
    check('uploader: batch done once', events.finished === 1, events.finished)
    check('uploader: no errors', eq(events.errors, []), events.errors)
  }

  // uploadInit rejection (the oversize-batch path) never reaches the POSTs.
  {
    const { events, callbacks } = reset()
    win.__requestPlan = () => ({ error: 'Maximum upload size exceeded' })

    await new Uploader({ inputId: 'upload', files: [file('big.csv', 10)], ...callbacks }).run()

    check('uploader: init error reported',
      eq(events.errors, ['Maximum upload size exceeded']), events.errors)
    check('uploader: init error skips POSTs', win.__posts.length === 0, win.__posts.length)
    check('uploader: init error skips uploadEnd',
      win.__requests.length === 1, win.__requests.map((r) => r.method))
    check('uploader: init error is not done', events.finished === 0, events.finished)
  }

  // A non-2xx POST fails the batch: no further files, no uploadEnd.
  {
    const { events, callbacks } = reset()
    win.__postPlan = () => ({ status: 500, responseText: 'upload handler failed' })

    await new Uploader({
      inputId: 'upload',
      files: [file('a.csv', 10), file('b.csv', 10)],
      ...callbacks
    }).run()

    check('uploader: POST error reported once',
      eq(events.errors, ['upload handler failed']), events.errors)
    check('uploader: POST error skips uploadEnd',
      win.__requests.every((r) => r.method === 'uploadInit'),
      win.__requests.map((r) => r.method))
    check('uploader: POST error is not done', events.finished === 0, events.finished)
  }

  // Cancel mid-batch: the in-flight POST is aborted, uploadEnd never runs,
  // so the server never sets the input value.
  {
    const { events, callbacks } = reset()
    win.__postPlan = () => ({ defer: true })

    const uploader = new Uploader({
      inputId: 'upload',
      files: [file('a.csv', 10), file('b.csv', 10)],
      ...callbacks
    })
    const running = uploader.run()

    await tick(20)
    check('uploader: both POSTs in flight', win.__deferredPosts.length === 2, win.__deferredPosts.length)

    uploader.cancel()
    await running

    check('uploader: cancel aborted every in-flight request',
      win.__deferredPosts.every((x) => x.aborted === true),
      win.__deferredPosts.map((x) => x.aborted))
    check('uploader: cancel skips uploadEnd',
      win.__requests.every((r) => r.method === 'uploadInit'),
      win.__requests.map((r) => r.method))
    check('uploader: cancel is neither done nor error',
      events.finished === 0 && events.errors.length === 0, events)
  }

  // Cancel with the pool full: the queue is dropped as well as the wire
  // cleared, so the files that never got a slot never get one.
  {
    const { events, callbacks } = reset()
    win.__postPlan = () => ({ defer: true })

    const names = ['a', 'b', 'c', 'd', 'e', 'f']
    const uploader = new Uploader({
      inputId: 'upload',
      files: names.map((n) => file(`${n}.csv`, 10)),
      ...callbacks
    })
    const running = uploader.run()

    await tick(20)
    check('uploader: queue-drop starts with the pool full',
      win.__posts.length === 4 && win.__deferredPosts.length === 4,
      { posts: win.__posts.length, inflight: win.__deferredPosts.length })

    uploader.cancel()
    await running
    await tick(20)

    check('uploader: cancel aborts the full pool',
      win.__deferredPosts.every((x) => x.aborted === true),
      win.__deferredPosts.map((x) => x.aborted))
    check('uploader: cancel never starts a queued file',
      eq(win.__posts.map((p) => p.name), ['a.csv', 'b.csv', 'c.csv', 'd.csv']),
      win.__posts.map((p) => p.name))
    check('uploader: cancel with a queue finishes no job',
      win.__requests.every((r) => r.method === 'uploadInit'),
      win.__requests.map((r) => r.method))
    check('uploader: cancel with a queue is neither done nor error',
      events.finished === 0 && events.errors.length === 0, events)
  }

  // No live connection: report it rather than issuing a dead uploadInit.
  {
    const { events, callbacks } = reset()
    win.__connected = false

    await new Uploader({ inputId: 'upload', files: [file('a.csv', 10)], ...callbacks }).run()

    check('uploader: disconnected reports an error', events.errors.length === 1, events.errors)
    check('uploader: disconnected makes no requests', win.__requests.length === 0, win.__requests)
  }


  // Completing out of declared order does not disturb which slot a file's
  // content lands in: the slot is its declared position, not its finish
  // rank, and that is the order R's batch handler rbinds them in.
  {
    const { events, callbacks } = reset()
    win.__postPlan = () => ({ defer: true })

    const uploader = new Uploader({
      inputId: 'upload',
      files: [file('first.csv', 10), file('second.csv', 10)],
      ...callbacks
    })
    const running = uploader.run()
    await tick(20)

    check('uploader: count is the batch size',
      uploader.count === 2, uploader.count)

    // Finish the second file first.
    const byUrl = (job) => win.__deferredPosts.find((x) => x.url.includes(job))
    for (const job of ['job2', 'job1']) {
      const xhr = byUrl(job)
      xhr.upload.onprogress({ lengthComputable: true, loaded: 10 })
      xhr.status = 200
      xhr.onload()
      await tick(10)
    }
    await running

    check('uploader: out-of-order completion finishes in completion order',
      eq(win.__requests.filter((r) => r.method === 'uploadEnd').map((r) => r.args),
        [['job2', 'upload__bsides_slot_2'], ['job1', 'upload__bsides_slot_1']]),
      win.__requests.filter((r) => r.method === 'uploadEnd').map((r) => r.args))
    check('uploader: each file finished into its declared slot',
      eq(win.__posts.map((p) => p.name), ['first.csv', 'second.csv']) &&
        win.__posts[0].url.includes('job1') && win.__posts[1].url.includes('job2'),
      win.__posts.map((p) => [p.name, p.url]))
    check('uploader: out-of-order batch still completes once',
      events.finished === 1 && events.errors.length === 0, events)
  }

  // The pool holds the line at UPLOAD_CONCURRENCY, and frees a slot as
  // each file lands.
  {
    const { events, callbacks } = reset()
    win.__postPlan = () => ({ defer: true })

    const names = ['a', 'b', 'c', 'd', 'e', 'f']
    const uploader = new Uploader({
      inputId: 'upload',
      files: names.map((n) => file(`${n}.csv`, 10)),
      ...callbacks
    })
    const running = uploader.run()
    await tick(20)

    check('uploader: init runs for every file before any POST',
      win.__requests.length === 6 && win.__posts.length === 4,
      { requests: win.__requests.length, posts: win.__posts.length })
    check('uploader: at most UPLOAD_CONCURRENCY in flight',
      win.__deferredPosts.length === 4, win.__deferredPosts.length)

    // Landing one file lets exactly one queued file start.
    const land = async () => {
      const xhr = win.__deferredPosts.shift()
      xhr.status = 200
      xhr.upload.onprogress({ lengthComputable: true, loaded: 10 })
      xhr.onload()
      await tick(10)
    }

    await land()
    check('uploader: a landed file frees exactly one slot',
      win.__posts.length === 5 && win.__deferredPosts.length === 4,
      { posts: win.__posts.length, inflight: win.__deferredPosts.length })

    while (win.__deferredPosts.length > 0) await land()
    await running

    check('uploader: every file uploaded exactly once',
      eq(win.__posts.map((p) => p.name).sort(), names.map((n) => `${n}.csv`).sort()),
      win.__posts.map((p) => p.name))
    check('uploader: bounded batch completes', events.finished === 1, events)
    check('uploader: every file reported done once',
      events.done.length === 6 && new Set(events.done).size === 6, events.done)
  }

  // The slot belongs to the POST, not to the job close. Every close is
  // held open here, so a chain that awaited its own close would park
  // every worker and the queued file would never start — which is what
  // makes this the check that the split actually happened. Holding one
  // close would prove nothing: the other workers would drain the queue.
  {
    const { events, callbacks } = reset()
    win.__requestPlan = (call) => (call.method === 'uploadEnd' ? { defer: true } : null)

    const names = Array.from(
      { length: UPLOAD_CONCURRENCY + 1 }, (_, i) => `f${i + 1}.csv`)

    // Never awaited: run() cannot settle while the closes are parked.
    void new Uploader({
      inputId: 'upload',
      files: names.map((n) => file(n, 10)),
      ...callbacks
    }).run()
    await tick(20)

    check('uploader: a landed file frees its slot before its job closes',
      eq(win.__posts.map((p) => p.name), names), win.__posts.map((p) => p.name))
    check('uploader: every job close is outstanding',
      win.__deferredRequests.length === names.length,
      win.__deferredRequests.length)
    check('uploader: no row is done while its close is outstanding',
      eq(events.done, []), events.done)

    // Every close but the last: the batch is still not delivered.
    while (win.__deferredRequests.length > 1) {
      win.__deferredRequests.shift().onSuccess({})
    }
    await tick(20)

    check('uploader: delivery waits for the last job to close',
      events.finished === 0 && events.done.length === names.length - 1,
      { finished: events.finished, done: events.done })

    win.__deferredRequests.shift().onSuccess({})
    await tick(20)

    check('uploader: the last close delivers the batch once',
      events.finished === 1 && events.done.length === names.length,
      { finished: events.finished, done: events.done })
    check('uploader: one close per file',
      win.__requests.filter((r) => r.method === 'uploadEnd').length === names.length,
      win.__requests.map((r) => r.method))
  }

  // A close that fails after every file's bytes have landed fails the
  // batch, and is reported from its own chain: its siblings' closes are
  // still outstanding, and a report joined behind them would never come.
  {
    const { events, callbacks } = reset()
    win.__requestPlan = (call) => (call.method === 'uploadEnd' ? { defer: true } : null)

    const names = ['a.csv', 'b.csv', 'c.csv']

    void new Uploader({
      inputId: 'upload',
      files: names.map((n) => file(n, 10)),
      ...callbacks
    }).run()
    await tick(20)

    check('uploader: close-failure starts with every POST landed',
      win.__posts.length === 3 && win.__deferredRequests.length === 3,
      { posts: win.__posts.length, closes: win.__deferredRequests.length })

    const second = win.__deferredRequests.find(
      (r) => r.args[1] === 'upload__bsides_slot_2')

    second.onError('could not finish upload')
    await tick(20)

    check('uploader: a failed close fails the batch at once',
      eq(events.errors, ['could not finish upload']), events.errors)
    check('uploader: a failed close names its own file',
      eq(events.errorFiles, ['b.csv']), events.errorFiles)
    check('uploader: a failed close delivers no value',
      events.finished === 0, events.finished)
  }

  // Cancel after the bytes have landed. The closes cannot be recalled —
  // Shiny has no abort for a request — so they settle into a dead batch,
  // which must deliver nothing and mark no row. The slots they set are
  // overwritten by the next batch's, which the wire delivers in order.
  {
    const { events, callbacks } = reset()
    win.__requestPlan = (call) => (call.method === 'uploadEnd' ? { defer: true } : null)

    const uploader = new Uploader({
      inputId: 'upload',
      files: [file('a.csv', 10), file('b.csv', 10)],
      ...callbacks
    })

    void uploader.run()
    await tick(20)

    check('uploader: cancel-with-closes starts with both closes outstanding',
      win.__posts.length === 2 && win.__deferredRequests.length === 2,
      { posts: win.__posts.length, closes: win.__deferredRequests.length })

    uploader.cancel()

    for (const request of win.__deferredRequests.splice(0)) {
      request.onSuccess({})
    }
    await tick(20)

    check('uploader: a cancelled batch delivers nothing though its jobs closed',
      events.finished === 0 && events.errors.length === 0, events)
    check('uploader: a cancelled batch marks no row done as its closes land',
      eq(events.done, []), events.done)

    // The retry is a fresh batch over the same slots.
    const retry = reset()

    await new Uploader({
      inputId: 'upload',
      files: [file('a.csv', 10), file('b.csv', 10)],
      ...retry.callbacks
    }).run()

    check('uploader: a batch after a cancel with closes outstanding delivers',
      retry.events.finished === 1 && retry.events.done.length === 2,
      retry.events)
  }

  // A file whose bytes have landed reads complete while its job closes.
  // The counter is settled at the file's size — its last progress event
  // may never have arrived — and reported under the file's own name, so
  // the row is not left short of 100% for as long as the close takes.
  {
    const { events, callbacks } = reset()
    win.__requestPlan = (call) => (call.method === 'uploadEnd' ? { defer: true } : null)
    win.__postPlan = () => ({ progress: [6] })

    void new Uploader({
      inputId: 'upload',
      files: [file('a.csv', 10)],
      ...callbacks
    }).run()
    await tick(20)

    const named = events.progress.filter(([name]) => name === 'a.csv')

    check('uploader: a landed file reports its full size while its job closes',
      eq(named.at(-1), ['a.csv', 10, 1]), named)
    check('uploader: a landed file is not done until its job closes',
      eq(events.done, []), events.done)
  }

  // Atomic failure: a file failing while others are in flight aborts them
  // and never starts the queued one.
  {
    const { events, callbacks } = reset()
    win.__postPlan = (call, i) =>
      (i === 0 ? { status: 500, responseText: 'disk full' } : { defer: true })

    await new Uploader({
      inputId: 'upload',
      files: ['a', 'b', 'c', 'd', 'e'].map((n) => file(`${n}.csv`, 10)),
      ...callbacks
    }).run()

    check('uploader: failure reported once', eq(events.errors, ['disk full']), events.errors)
    check('uploader: failure aborts the files in flight',
      win.__deferredPosts.every((x) => x.aborted === true),
      win.__deferredPosts.map((x) => x.aborted))
    check('uploader: failure never starts the queued file',
      win.__posts.length === 4, win.__posts.map((p) => p.name))
    check('uploader: failure finishes no job',
      win.__requests.every((r) => r.method === 'uploadInit'),
      win.__requests.map((r) => r.method))
    check('uploader: failure is not done', events.finished === 0, events.finished)
  }

  // A failure is reported as it happens, not once every transfer chain has
  // settled: a sibling waiting on `uploadEnd` over a dropped socket waits
  // forever, and holding the report behind it would strand the batch in
  // 'uploading' with no error ever raised.
  {
    const { events, callbacks } = reset()
    win.__postPlan = (call) => (call.name === 'a.csv' ? { defer: true } : {})
    win.__requestPlan = (call) => (call.method === 'uploadEnd' ? { hang: true } : null)

    const uploader = new Uploader({
      inputId: 'upload',
      files: [file('a.csv', 10), file('b.csv', 10)],
      ...callbacks
    })

    // Deliberately not awaited: run() cannot settle while b.csv's
    // uploadEnd hangs, which is the condition under test. file.ts fires it
    // as `void uploader.run()` for the same reason.
    void uploader.run()
    await tick(20)

    check('uploader: sibling reached a hung uploadEnd',
      win.__requests.filter((r) => r.method === 'uploadEnd').length === 1,
      win.__requests.map((r) => r.method))

    const [posted] = win.__deferredPosts
    posted.status = 500
    posted.responseText = 'upload handler failed'
    posted.onload()
    await tick(20)

    check('uploader: POST failure reported despite a hung sibling',
      eq(events.errors, ['upload handler failed']), events.errors)
    check('uploader: hung batch marks the file that actually failed',
      eq(events.errorFiles, ['a.csv']), events.errorFiles)
    check('uploader: hung batch is not done', events.finished === 0, events.finished)
  }

  // Progress from two files interleaves without the batch fraction ever
  // walking backwards.
  {
    const { events, callbacks } = reset()
    win.__postPlan = () => ({ defer: true })

    const running = new Uploader({
      inputId: 'upload',
      files: [file('big.csv', 100), file('small.csv', 100)],
      ...callbacks
    }).run()
    await tick(20)

    const [one, two] = win.__deferredPosts
    for (const [xhr, loaded] of [[one, 20], [two, 30], [one, 60], [two, 90], [one, 100]]) {
      xhr.upload.onprogress({ lengthComputable: true, loaded })
    }
    for (const xhr of [one, two]) {
      xhr.status = 200
      xhr.onload()
      await tick(10)
    }
    await running

    const fractions = events.progress.map(([, , batch]) => batch)
    check('uploader: interleaved progress never decreases',
      fractions.every((f, i) => i === 0 || f >= fractions[i - 1]), fractions)
    check('uploader: interleaved progress reaches exactly 1',
      fractions[fractions.length - 1] === 1, fractions)
    check('uploader: each checkpoint carries its own file\'s bytes',
      events.progress.some(([n, loaded]) => n === 'big.csv' && loaded === 60) &&
        events.progress.some(([n, loaded]) => n === 'small.csv' && loaded === 90),
      events.progress)
    check('uploader: both files done', eq(events.done.sort(), ['big.csv', 'small.csv']),
      events.done)
  }

  // A transfer that restarts its progress sequence reports fewer bytes
  // than it last did. The batch bar holds where it was rather than
  // rewinding.
  {
    const { events, callbacks } = reset()
    win.__postPlan = () => ({ defer: true })

    const running = new Uploader({
      inputId: 'upload',
      files: [file('one.csv', 100), file('two.csv', 100)],
      ...callbacks
    }).run()
    await tick(20)

    const [one, two] = win.__deferredPosts
    one.upload.onprogress({ lengthComputable: true, loaded: 60 })
    two.upload.onprogress({ lengthComputable: true, loaded: 40 })

    const before = events.progress[events.progress.length - 1][2]

    // one.csv starts over: 60 bytes of credit evaporate.
    one.upload.onprogress({ lengthComputable: true, loaded: 10 })

    const after = events.progress[events.progress.length - 1][2]

    check('uploader: a restarted transfer does not rewind the batch',
      after >= before, { before, after })

    // The file's own row holds too: the counter behind both bars is the
    // one that is kept monotone.
    const rewound = events.progress
      .filter(([name]) => name === 'one.csv')
      .map(([, loaded]) => loaded)

    check('uploader: a restarted transfer does not rewind its own row',
      rewound.every((n, i) => i === 0 || n >= rewound[i - 1]), rewound)

    for (const xhr of [one, two]) {
      xhr.upload.onprogress({ lengthComputable: true, loaded: 100 })
      xhr.status = 200
      xhr.onload()
      await tick(10)
    }
    await running

    const fractions = events.progress.map(([, , batch]) => batch)
    check('uploader: restarted transfer still ends at 1',
      fractions[fractions.length - 1] === 1 && events.finished === 1, fractions)
  }

  // An empty batch is done without touching the wire.
  {
    const { events, callbacks } = reset()

    await new Uploader({ inputId: 'upload', files: [], ...callbacks }).run()

    check('uploader: empty batch is done', events.finished === 1, events)
    check('uploader: empty batch makes no requests',
      win.__requests.length === 0 && win.__posts.length === 0,
      { requests: win.__requests.length, posts: win.__posts.length })
    check('uploader: empty batch reports no error', eq(events.errors, []), events.errors)
  }

  // A batch of one is the degenerate case of the pool: a single job,
  // a single POST, and slot 1 — no concurrency machinery observable.
  {
    const { events, callbacks } = reset()

    await new Uploader({
      inputId: 'upload',
      files: [file('only.csv', 10)],
      ...callbacks
    }).run()

    check('uploader: single file runs one job',
      eq(win.__requests.map((r) => r.method), ['uploadInit', 'uploadEnd']),
      win.__requests.map((r) => r.method))
    check('uploader: single file finishes into slot 1',
      eq(win.__requests[1].args, ['job1', 'upload__bsides_slot_1']),
      win.__requests[1].args)
    check('uploader: single file posts once',
      eq(win.__posts.map((p) => p.name), ['only.csv']), win.__posts.map((p) => p.name))
    check('uploader: single file done once',
      events.finished === 1 && eq(events.done, ['only.csv']), events)
  }

  reset()
}

console.log(`\n${checks} checks, ${failures.length} failures`)
for (const f of failures) console.log(f)
process.exit(failures.length ? 1 : 0)
