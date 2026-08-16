import {
  NativeEventInputBinding,
  registerBinding,
  announce,
  findAll,
  hasDefinedProperty,
} from './_utils';

type CheckboxGroupReceiveMessageData = {
  options?: string;
  select?: string[];
  disable?: string[];
};

class CheckboxGroupInputBinding extends NativeEventInputBinding {
  override find(scope: HTMLElement): JQuery<HTMLElement> {
    return findAll(scope, '.bsides-input-checkbox-group');
  }

  // Matches the input handler registered by the R side.
  override getType(el: HTMLElement): string | null {
    void el;
    return 'bsides.checkboxgroup';
  }

  override getValue(el: HTMLElement): string[] {
    return this.#checkboxesOf(el)
      .filter((checkbox) => checkbox.checked)
      .map((checkbox) => checkbox.value);
  }

  override subscribe(
    el: HTMLElement,
    callback: (allowDeferred: boolean) => void,
  ): void {
    this.listen(el, 'change', () => {
      callback(false);
    });
  }

  override getState(el: HTMLElement): { value: string[] } {
    return {
      value: this.getValue(el),
    };
  }

  override receiveMessage(
    el: HTMLElement,
    data: CheckboxGroupReceiveMessageData,
  ): void {
    if (hasDefinedProperty(data, 'options')) {
      el.innerHTML = data.options!;
    }

    const checkboxes = this.#checkboxesOf(el);

    if (hasDefinedProperty(data, 'select')) {
      for (const checkbox of checkboxes) {
        checkbox.checked = data.select!.includes(checkbox.value);
      }
    }

    if (hasDefinedProperty(data, 'disable')) {
      for (const checkbox of checkboxes) {
        checkbox.disabled = data.disable!.includes(checkbox.value);
      }
    }

    announce(el);
  }

  #checkboxesOf(el: HTMLElement): HTMLInputElement[] {
    return [
      ...el.querySelectorAll<HTMLInputElement>('.form-check-input,.btn-check'),
    ];
  }
}

registerBinding(CheckboxGroupInputBinding, 'checkboxgroup');

export { CheckboxGroupInputBinding };
export type { CheckboxGroupReceiveMessageData };
