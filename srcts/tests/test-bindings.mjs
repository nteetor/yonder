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
  'menu', 'chip-group', 'chip-group-none', 'chip-group-select',
  'multi-select', 'multi-select-free', 'radio-group', 'range', 'select',
  'text-group', 'modal'
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

console.log(`\n${checks} checks, ${failures.length} failures`)
for (const f of failures) console.log(f)
process.exit(failures.length ? 1 : 0)
