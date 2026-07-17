import $ from 'jquery'

import { NativeEventInputBinding, registerBinding } from './_utils'
import './webcomponents/multiSelect'
import type {
  BsidesMultiSelect,
  MultiSelectUpdate
} from './webcomponents/multiSelect'

// Thin adapter over <bsides-multi-select>: the element owns all state and
// behavior; the binding only relays values and change notifications.
// Listener cleanup is inherited from NativeEventInputBinding.
class MultiSelectInputBinding extends NativeEventInputBinding {
  override find(scope: HTMLElement): JQuery<HTMLElement> {
    return $(scope).find('bsides-multi-select')
  }

  override getValue(el: HTMLElement): string[] {
    return (el as BsidesMultiSelect).chips
  }

  // Matches the input handler registered by the R side (empty selection
  // becomes NULL).
  override getType(el: HTMLElement): string | null {
    void el
    return 'bsides.multiselect'
  }

  override subscribe(
    el: HTMLElement,
    callback: (allowDeferred: boolean) => void
  ): void {
    this.listen(el, 'bsides-multi-select:change', () => {
      callback(false)
    })
  }

  // All state changes live in the component; the binding only forwards.
  override receiveMessage(el: HTMLElement, data: MultiSelectUpdate): void {
    ;(el as BsidesMultiSelect).receiveUpdate(data)
  }
}

registerBinding(MultiSelectInputBinding, 'multiselect')

export { MultiSelectInputBinding }
