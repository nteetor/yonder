// Modeled on Shiny's NumberInputBinding (srcts/src/bindings/input/number.ts).

import {
  NativeEventInputBinding,
  registerBinding,
  announce,
  findAll,
  hasDefinedProperty,
} from './_utils';

type NumericHTMLElement = HTMLInputElement;

// `format_no_sci()` sends the numeric keys as strings, but a hand-built message
// may still carry numbers. An explicit null clears the attribute, as it does in
// shiny.
type NumericValue = number | string | null;

type NumericReceiveMessageData = {
  value?: NumericValue;
  min?: NumericValue;
  max?: NumericValue;
  step?: NumericValue;
  disable?: boolean;
};

// Attribute writes are string assignments, and a cleared attribute is "".
function asAttr(value: NumericValue | undefined): string {
  return value == null ? '' : `${value}`;
}

class NumericInputBinding extends NativeEventInputBinding {
  override find(scope: HTMLElement): JQuery<HTMLElement> {
    return findAll(scope, '.bsides-input-numeric');
  }

  // An empty or unparseable field reports `null`, which reaches the server as
  // `NULL`. Shiny's binding returns the raw string when it cannot parse; that
  // would hand R a character where it expects a number.
  override getValue(el: NumericHTMLElement): number | null {
    if (/^\s*$/.test(el.value)) {
      return null;
    }

    const value = Number(el.value);

    return isNaN(value) ? null : value;
  }

  setValue(el: NumericHTMLElement, value: NumericValue): void {
    el.value = asAttr(value);
  }

  override subscribe(
    el: NumericHTMLElement,
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

  override getState(el: NumericHTMLElement): {
    value: number | null;
    min: string;
    max: string;
    step: string;
  } {
    return {
      value: this.getValue(el),
      min: el.min,
      max: el.max,
      step: el.step,
    };
  }

  override receiveMessage(
    el: NumericHTMLElement,
    data: NumericReceiveMessageData,
  ): void {
    if (hasDefinedProperty(data, 'value')) {
      this.setValue(el, data.value!);
    }

    if (hasDefinedProperty(data, 'min')) {
      el.min = asAttr(data.min);
    }

    if (hasDefinedProperty(data, 'max')) {
      el.max = asAttr(data.max);
    }

    if (hasDefinedProperty(data, 'step')) {
      el.step = asAttr(data.step);
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

registerBinding(NumericInputBinding, 'numeric');

export { NumericInputBinding };
export type { NumericHTMLElement, NumericReceiveMessageData };
