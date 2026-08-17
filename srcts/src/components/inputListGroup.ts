import {
  NativeEventInputBinding,
  registerBinding,
  announce,
  findAll,
  hasDefinedProperty,
} from './_utils';

type ListGroupReceiveMessageData = {
  select?: string[];
  disable?: string[];
};

class ListGroupInputBinding extends NativeEventInputBinding {
  override find(scope: HTMLElement): JQuery<HTMLElement> {
    return findAll(scope, '.bsides-input-list-group');
  }

  override getValue(el: HTMLElement): Array<string | null> {
    return [...el.querySelectorAll('.list-group-item-action.active')].map((e) =>
      e.getAttribute('data-bsides-value'),
    );
  }

  override subscribe(
    el: HTMLElement,
    callback: (allowDeferred: boolean) => void,
  ): void {
    this.listenDelegated(el, 'click', '.list-group-item-action', (_, item) => {
      item.classList.toggle('active');
      callback(false);
    });

    // Server updates via receiveMessage() are announced with a change event.
    this.listen(el, 'change', () => {
      callback(false);
    });
  }

  override getState(el: HTMLElement): { value: Array<string | null> } {
    return {
      value: this.getValue(el),
    };
  }

  override receiveMessage(
    el: HTMLElement,
    data: ListGroupReceiveMessageData,
  ): void {
    const choices = el.querySelectorAll<HTMLButtonElement>(
      '.list-group-item-action',
    );

    const valueOf = (e: HTMLElement) =>
      e.getAttribute('data-bsides-value') ?? '';

    if (hasDefinedProperty(data, 'select')) {
      for (const choice of choices) {
        choice.classList.toggle(
          'active',
          data.select!.includes(valueOf(choice)),
        );
      }
    }

    if (hasDefinedProperty(data, 'disable')) {
      for (const choice of choices) {
        const disable = data.disable!.includes(valueOf(choice));

        choice.classList.toggle('disabled', disable);
        choice.disabled = disable;
      }
    }

    announce(el);
  }
}

registerBinding(ListGroupInputBinding, 'listgroup');

export { ListGroupInputBinding };
export type { ListGroupReceiveMessageData };
