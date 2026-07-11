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

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../..')

const read = (f) => fs.readFileSync(path.join(root, f), 'utf8')
const html = (name) => read(path.join('srcts/tests/html', `${name}.html`))
const tick = (ms = 60) => new Promise((r) => setTimeout(r, ms))

const body = [
  'button', 'checkbox', 'checkbox-group', 'form', 'link', 'list-group',
  'menu', 'multi-select', 'multi-select-preset', 'radio-group', 'range',
  'select', 'text-group', 'modal', 'toast'
].map((n) => `<section data-component="${n}">${html(n)}</section>`).join('\n')
  + '<div id="toast-container"></div>'

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

win.eval(read('node_modules/jquery/dist/jquery.js'))
win.eval(read('node_modules/bootstrap/dist/js/bootstrap.bundle.js'))
win.eval(read('inst/www/yonder/js/bsides.js'))

const registered = win.__registered
const handlers = win.__handlers

// Shiny-like bind: find elements, initialize, subscribe with a recording
// callback that captures the value at event time.
function bind(name) {
  const binding = registered[name]
  if (!binding) throw new Error(`binding not registered: ${name}`)

  const els = binding.find(doc.body).get()
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
  binding.receiveMessage(el, { text: 'Go', disable: true })
  check('button: text updated', el.innerHTML === 'Go', el.innerHTML)
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

// ---- multi-select ----
{
  const { binding, els, events } = bind('bsides.multiselect')
  const el = doc.getElementById('ms')
  await tick(20) // let Lit render

  const input = el.querySelector('.multi-select-input')
  check('multiselect: found', els.includes(el))
  check('multiselect: initial empty', eq(binding.getValue(el), []), binding.getValue(el))

  input.value = 'Tag1'
  native(input, 'keydown', win.KeyboardEvent, { key: 'Enter' })
  await tick(20)
  check('multiselect: enter adds chip', eq(binding.getValue(el), ['Tag1']), binding.getValue(el))
  check('multiselect: input cleared', input.value === '')
  check('multiselect: change event fired', events.length === 1, events.length)
  check('multiselect: chip rendered', el.querySelectorAll('bsides-chip').length === 1)

  input.value = '   '
  native(input, 'keydown', win.KeyboardEvent, { key: 'Enter' })
  await tick(20)
  check('multiselect: blank text ignored', eq(binding.getValue(el), ['Tag1']), binding.getValue(el))

  // Duplicates rejected; the typed text stays visible.
  input.value = 'Tag1'
  native(input, 'keydown', win.KeyboardEvent, { key: 'Enter' })
  await tick(20)
  check('multiselect: duplicate rejected', eq(binding.getValue(el), ['Tag1']), binding.getValue(el))
  check('multiselect: duplicate text kept', input.value === 'Tag1')
  input.value = ''

  // Backspace in an empty input removes the last chip.
  native(input, 'keydown', win.KeyboardEvent, { key: 'Backspace' })
  await tick(20)
  check('multiselect: backspace removes last', eq(binding.getValue(el), []), binding.getValue(el))

  // Close button removes the chip; value reported post-removal.
  input.value = 'Tag2'
  native(input, 'keydown', win.KeyboardEvent, { key: 'Enter' })
  await tick(20)
  el.querySelector('bsides-chip .btn-close').click()
  await tick(20)
  check('multiselect: chip removed after close', eq(binding.getValue(el), []), binding.getValue(el))
  check(
    'multiselect: server sees post-removal value',
    events.at(-1)?.value.length === 0,
    events.at(-1)
  )

  // Preset element: initial chips from the value attribute, max limit.
  const el2 = doc.getElementById('ms2')
  const input2 = el2.querySelector('.multi-select-input')
  check('multiselect: initial chips from attribute', eq(binding.getValue(el2), ['A', 'B']), binding.getValue(el2))

  input2.value = 'C'
  native(input2, 'keydown', win.KeyboardEvent, { key: 'Enter' })
  await tick(20)
  check('multiselect: adds up to max', eq(binding.getValue(el2), ['A', 'B', 'C']), binding.getValue(el2))
  check('multiselect: input disabled at max', input2.disabled === true)

  el2.querySelector('bsides-chip .btn-close').click()
  await tick(20)
  check('multiselect: removal below max re-enables', input2.disabled === false)
  check('multiselect: value after removal', eq(binding.getValue(el2), ['B', 'C']), binding.getValue(el2))

  // unsubscribe aborts the listener: further changes are not reported.
  const before = events.length
  binding.unsubscribe(el2)
  input2.value = 'D'
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

// ---- toast ----
{
  const { binding, els, events } = bind('bsides.toast')
  check('toast: found', els.length === 1, els.length)
  check('toast: initial hidden', binding.getValue(els[0]) === 'hidden', binding.getValue(els[0]))

  binding.receiveMessage(els[0], { method: 'show' })
  await tick(100)
  check('toast: shown', binding.getValue(els[0]) === 'shown', binding.getValue(els[0]))
  check('toast: shown event fired', events.some((e) => e.value === 'shown'), events)

  binding.receiveMessage(els[0], { method: 'hide' })
  await tick(400)
  check('toast: hidden again', binding.getValue(els[0]) === 'hidden', binding.getValue(els[0]))

  await handlers['bsides:toastAdd']({
    target: 'toast-container',
    toast: '<div class="bsides-toast toast" id="t2">More</div>'
  })
  check('toast: toastAdd inserts', doc.getElementById('t2') !== null)
}

console.log(`\n${checks} checks, ${failures.length} failures`)
for (const f of failures) console.log(f)
process.exit(failures.length ? 1 : 0)
