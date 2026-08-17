import {
  NativeEventInputBinding,
  registerBinding,
  announce,
  findAll,
  hasDefinedProperty,
} from './_utils';

type RangeReceiveMessageData = {
  value?: number;
  disable?: boolean;
};

class RangeInputBinding extends NativeEventInputBinding {
  override find(scope: HTMLElement): JQuery<HTMLElement> {
    return findAll(scope, '.bsides-input-range');
  }

  override getValue(el: HTMLElement): number {
    return Number(this.#rangeOf(el).value);
  }

  override subscribe(
    el: HTMLElement,
    callback: (allowDeferred: boolean) => void,
  ): void {
    this.listen(el, 'change', () => {
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
    data: RangeReceiveMessageData,
  ): void {
    const range = this.#rangeOf(el);

    if (hasDefinedProperty(data, 'value')) {
      range.value = String(data.value!);
    }

    if (hasDefinedProperty(data, 'disable')) {
      range.disabled = data.disable!;
    }

    announce(el);
  }

  #rangeOf(el: HTMLElement): HTMLInputElement {
    return el.querySelector<HTMLInputElement>('.form-range')!;
  }
}

registerBinding(RangeInputBinding, 'range');

export { RangeInputBinding };
export type { RangeReceiveMessageData };
