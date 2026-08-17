// Modeled on Shiny's TextInputBinding (srcts/src/bindings/input/text.ts).

import {
  NativeEventInputBinding,
  registerBinding,
  announce,
  findAll,
  hasDefinedProperty,
} from './_utils';

type TextHTMLElement = HTMLInputElement;

type TextReceiveMessageData = {
  value?: TextHTMLElement['value'];
  disable?: boolean;
};

class TextInputBinding extends NativeEventInputBinding {
  override find(scope: HTMLElement): JQuery<HTMLElement> {
    return findAll(scope, '.bsides-input-text');
  }

  override getValue(el: TextHTMLElement): TextHTMLElement['value'] {
    return el.value;
  }

  setValue(el: TextHTMLElement, value: string): void {
    el.value = value;
  }

  override subscribe(
    el: TextHTMLElement,
    callback: (allowDeferred: boolean) => void,
  ): void {
    // Rapid-fire events defer to the rate policy (debounce); committed
    // changes are sent immediately.
    this.listen(el, 'keyup', () => {
      callback(true);
    });

    this.listen(el, 'input', () => {
      callback(true);
    });

    this.listen(el, 'change', () => {
      callback(false);
    });
  }

  override getState(el: TextHTMLElement): { value: string } {
    return {
      value: el.value,
    };
  }

  override receiveMessage(
    el: TextHTMLElement,
    data: TextReceiveMessageData,
  ): void {
    if (hasDefinedProperty(data, 'value')) {
      this.setValue(el, data.value!);
    }

    if (hasDefinedProperty(data, 'disable')) {
      el.disabled = data.disable!;
    }

    announce(el);
  }

  override getRatePolicy(el: HTMLElement): {
    policy: 'debounce';
    delay: number;
  } {
    void el;
    return {
      policy: 'debounce',
      delay: 250,
    };
  }
}

registerBinding(TextInputBinding, 'text');

export { TextInputBinding };
export type { TextHTMLElement, TextReceiveMessageData };
