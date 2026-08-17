import {
  NativeEventInputBinding,
  registerBinding,
  announce,
  findAll,
  hasDefinedProperty,
} from './_utils';

type MenuReceiveMessageData = {
  label?: string;
  select?: string;
  disable?: string[];
};

const menuValues = new WeakMap<HTMLElement, string>();

class MenuInputBinding extends NativeEventInputBinding {
  override find(scope: HTMLElement): JQuery<HTMLElement> {
    return findAll(scope, '.bsides-input-menu');
  }

  override getValue(el: HTMLElement): unknown {
    return menuValues.get(el);
  }

  override subscribe(
    el: HTMLElement,
    callback: (allowDeferred: boolean) => void,
  ): void {
    this.listenDelegated(el, 'click', '.dropdown-item', (_, item) => {
      menuValues.set(el, (item as HTMLButtonElement).value);
      callback(false);
    });

    // Server updates via receiveMessage() are announced with a change event.
    this.listen(el, 'change', () => {
      callback(false);
    });
  }

  override getState(el: HTMLElement): { value: unknown } {
    return {
      value: this.getValue(el),
    };
  }

  override receiveMessage(el: HTMLElement, data: MenuReceiveMessageData): void {
    if (hasDefinedProperty(data, 'label')) {
      const toggle = el.querySelector(':scope > .dropdown-toggle');

      if (toggle) {
        toggle.innerHTML = data.label!;
      }
    }

    if (hasDefinedProperty(data, 'disable')) {
      const choices = el.querySelectorAll<HTMLButtonElement>('.dropdown-item');

      for (const choice of choices) {
        const disable = data.disable!.includes(choice.value);

        choice.disabled = disable;
        choice.classList.toggle('disabled', disable);
      }
    }

    if (hasDefinedProperty(data, 'select')) {
      menuValues.set(el, data.select!);
      announce(el);
    }
  }
}

registerBinding(MenuInputBinding, 'menu');

export { MenuInputBinding };
export type { MenuReceiveMessageData };
