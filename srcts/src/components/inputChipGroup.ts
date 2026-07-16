import $ from 'jquery'

import { NativeEventInputBinding, registerBinding } from './_utils'
import './webcomponents/chipGroup'
import type {
  BsidesChipGroup,
  ChipGroupUpdate
} from './webcomponents/chipGroup'

// Thin adapter over <bsides-chip-group>: the element owns all state and
// behavior; the binding only relays values and change notifications.
// Listener cleanup is inherited from NativeEventInputBinding.
class ChipGroupInputBinding extends NativeEventInputBinding {
  override find(scope: HTMLElement): JQuery<HTMLElement> {
    return $(scope).find('bsides-chip-group')
  }

  override getValue(el: HTMLElement): string[] {
    return (el as BsidesChipGroup).checked
  }

  // Matches the input handler registered by the R side (empty selection
  // becomes NULL).
  override getType(el: HTMLElement): string | null {
    void el
    return 'bsides.chipgroup'
  }

  override subscribe(
    el: HTMLElement,
    callback: (allowDeferred: boolean) => void
  ): void {
    this.listen(el, 'bsides-chip-group:change', () => {
      callback(false)
    })
  }

  // All state changes live in the component; the binding only forwards.
  override receiveMessage(el: HTMLElement, data: ChipGroupUpdate): void {
    ;(el as BsidesChipGroup).receiveUpdate(data)
  }
}

registerBinding(ChipGroupInputBinding, 'chipgroup')

export { ChipGroupInputBinding }
