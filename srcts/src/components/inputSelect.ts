import {
  NativeEventInputBinding,
  registerBinding,
  announce,
  findAll,
  hasDefinedProperty,
} from './_utils';

type SelectHTMLElement = HTMLSelectElement;

type SelectReceiveMessageData = {
  options?: string;
  select?: string;
  disable?: string[];
};

class SelectInputBinding extends NativeEventInputBinding {
  override find(scope: HTMLElement): JQuery<HTMLElement> {
    return findAll(scope, '.bsides-input-select');
  }

  override getValue(el: SelectHTMLElement): string {
    return el.value;
  }

  setValue(el: SelectHTMLElement, value: string): void {
    el.value = value;
  }

  override subscribe(
    el: SelectHTMLElement,
    callback: (allowDeferred: boolean) => void,
  ): void {
    this.listen(el, 'change', () => {
      callback(false);
    });
  }

  override getState(el: SelectHTMLElement): { value: string } {
    return {
      value: el.value,
    };
  }

  override receiveMessage(
    el: SelectHTMLElement,
    data: SelectReceiveMessageData,
  ): void {
    if (hasDefinedProperty(data, 'options')) {
      el.innerHTML = data.options!;
    }

    if (hasDefinedProperty(data, 'select')) {
      this.setValue(el, data.select!);
    }

    if (hasDefinedProperty(data, 'disable')) {
      for (const option of el.options) {
        option.disabled = data.disable!.includes(option.value);
      }
    }

    announce(el);
  }
}

registerBinding(SelectInputBinding, 'select');

export { SelectInputBinding };
export type { SelectHTMLElement, SelectReceiveMessageData };
