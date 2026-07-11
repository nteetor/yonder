import $ from 'jquery'

import { NativeEventInputBinding, registerBinding } from './_utils'
import './webcomponents/multiSelect'
import type { BsidesMultiSelect } from './webcomponents/multiSelect'

// Thin adapter over <bsides-multi-select>: the element owns all state and
// behavior; the binding only relays values and change notifications.
// Listener cleanup is inherited from NativeEventInputBinding.
class MultiSelectInputBinding extends NativeEventInputBinding {
  override find(scope: HTMLElement): JQuery<HTMLElement> {
    return $(scope).find('bsides-multi-select')
  }

  override getValue(el: HTMLElement): string[] {
    return (el as BsidesMultiSelect).value
  }

  override subscribe(
    el: HTMLElement,
    callback: (allowDeferred: boolean) => void
  ): void {
    this.listen(el, 'bsides-multi-select:change', () => {
      callback(false)
    })
  }

  // update_multi_select() is still a stub on the R side; wiring arrives in
  // phase 2 of the multi-select plan.
  override receiveMessage(el: HTMLElement, data: unknown): void {
    void el
    void data
  }
}

registerBinding(MultiSelectInputBinding, 'multiselect')

export { MultiSelectInputBinding }
