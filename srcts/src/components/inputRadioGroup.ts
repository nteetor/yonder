import {
  NativeEventInputBinding,
  registerBinding,
  announce,
  findAll,
  hasDefinedProperty,
} from './_utils';

type RadioGroupReceiveMessageData = {
  options?: string;
  select?: string[];
  disable?: string[];
};

class RadioGroupInputBinding extends NativeEventInputBinding {
  override find(scope: HTMLElement): JQuery<HTMLElement> {
    return findAll(scope, '.bsides-input-radio-group');
  }

  override getValue(el: HTMLElement): string | undefined {
    return el.querySelector<HTMLInputElement>(
      '.form-check-input:checked,.btn-check:checked',
    )?.value;
  }

  override subscribe(
    el: HTMLElement,
    callback: (allowDeferred: boolean) => void,
  ): void {
    this.listen(el, 'change', () => {
      callback(false);
    });
  }

  override getState(el: HTMLElement): { value: unknown } {
    return {
      value: this.getValue(el),
    };
  }

  override receiveMessage(
    el: HTMLElement,
    data: RadioGroupReceiveMessageData,
  ): void {
    if (hasDefinedProperty(data, 'options')) {
      el.innerHTML = data.options!;
    }

    const radios = el.querySelectorAll<HTMLInputElement>(
      '.form-check-input,.btn-check',
    );

    if (hasDefinedProperty(data, 'select')) {
      for (const radio of radios) {
        radio.checked = data.select!.includes(radio.value);
      }
    }

    if (hasDefinedProperty(data, 'disable')) {
      for (const radio of radios) {
        radio.disabled = data.disable!.includes(radio.value);
      }
    }

    announce(el);
  }
}

registerBinding(RadioGroupInputBinding, 'radiogroup');

export { RadioGroupInputBinding };
export type { RadioGroupReceiveMessageData };
