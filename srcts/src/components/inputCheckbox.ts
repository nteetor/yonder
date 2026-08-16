import {
  NativeEventInputBinding,
  registerBinding,
  announce,
  findAll,
  hasDefinedProperty,
} from './_utils';

type CheckboxReceiveMessageData = {
  choice?: string;
  value?: boolean;
  disable?: boolean;
};

class CheckboxInputBinding extends NativeEventInputBinding {
  override find(scope: HTMLElement): JQuery<HTMLElement> {
    return findAll(scope, '.bsides-input-checkbox');
  }

  override getValue(el: HTMLElement): boolean {
    return this.#checkboxOf(el).checked;
  }

  override subscribe(
    el: HTMLElement,
    callback: (allowDeferred: boolean) => void,
  ): void {
    this.listen(el, 'change', () => {
      callback(false);
    });
  }

  override getState(el: HTMLElement): { value: boolean } {
    return {
      value: this.getValue(el),
    };
  }

  override receiveMessage(
    el: HTMLElement,
    data: CheckboxReceiveMessageData,
  ): void {
    if (hasDefinedProperty(data, 'choice')) {
      const label = el.querySelector('.form-check-label');

      if (label) {
        label.innerHTML = data.choice!;
      }
    }

    if (hasDefinedProperty(data, 'value')) {
      this.#checkboxOf(el).checked = data.value!;
    }

    if (hasDefinedProperty(data, 'disable')) {
      this.#checkboxOf(el).disabled = data.disable!;
    }

    announce(el);
  }

  #checkboxOf(el: HTMLElement): HTMLInputElement {
    return el.querySelector<HTMLInputElement>(':scope > .form-check-input')!;
  }
}

registerBinding(CheckboxInputBinding, 'checkbox');

export { CheckboxInputBinding };
export type { CheckboxReceiveMessageData };
