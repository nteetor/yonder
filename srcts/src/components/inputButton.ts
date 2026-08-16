// Modeled on Shiny's ActionButtonInputBinding.

import {
  NativeEventInputBinding,
  registerBinding,
  findAll,
  hasDefinedProperty,
} from './_utils';

type ButtonReceiveMessageData = {
  label?: string;
  disable?: boolean;
};

class ButtonInputBinding extends NativeEventInputBinding {
  override find(scope: HTMLElement): JQuery<HTMLElement> {
    return findAll(scope, '.bsides-input-button');
  }

  override getValue(el: HTMLElement): number {
    return Number(el.dataset.bsidesClicks) || 0;
  }

  // Matches the input handler registered by the R side.
  override getType(el: HTMLElement): string | null {
    void el;
    return 'bsides.button';
  }

  override subscribe(
    el: HTMLElement,
    callback: (allowDeferred: boolean) => void,
  ): void {
    this.listen(el, 'click', () => {
      el.dataset.bsidesClicks = String(this.getValue(el) + 1);
      callback(false);
    });
  }

  override getState(el: HTMLElement): { value: number } {
    return {
      value: this.getValue(el),
    };
  }

  override receiveMessage(
    el: HTMLElement,
    data: ButtonReceiveMessageData,
  ): void {
    const button = el as HTMLButtonElement;

    if (hasDefinedProperty(data, 'label')) {
      button.innerHTML = data.label!;
    }

    if (hasDefinedProperty(data, 'disable')) {
      button.disabled = data.disable!;
    }
  }
}

registerBinding(ButtonInputBinding, 'button');

export { ButtonInputBinding };
export type { ButtonReceiveMessageData };
