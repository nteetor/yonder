import {
  NativeEventInputBinding,
  registerBinding,
  announce,
  findAll,
  hasDefinedProperty,
} from './_utils';

type TextGroupReceiveMessageData = {
  value?: string;
  disable?: boolean;
};

class TextGroupInputBinding extends NativeEventInputBinding {
  override find(scope: HTMLElement): JQuery<HTMLElement> {
    return findAll(scope, '.bsides-input-text-group');
  }

  override getValue(el: HTMLElement): string | null {
    if (!this.#inputOf(el).value) {
      return null;
    }

    return [...el.querySelectorAll('.input-group-text,input')]
      .map((e) => e.textContent || (e as HTMLInputElement).value || '')
      .join('');
  }

  override subscribe(
    el: HTMLElement,
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

  override getState(el: HTMLElement): { value: string | null } {
    return {
      value: this.getValue(el),
    };
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

  override receiveMessage(
    el: HTMLElement,
    data: TextGroupReceiveMessageData,
  ): void {
    const input = this.#inputOf(el);

    if (hasDefinedProperty(data, 'value')) {
      input.value = data.value!;
    }

    if (hasDefinedProperty(data, 'disable')) {
      input.disabled = data.disable!;
    }

    announce(el);
  }

  #inputOf(el: HTMLElement): HTMLInputElement {
    return el.querySelector<HTMLInputElement>('input')!;
  }
}

registerBinding(TextGroupInputBinding, 'textgroup');

export { TextGroupInputBinding };
export type { TextGroupReceiveMessageData };
