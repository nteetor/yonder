import { NativeEventInputBinding, registerBinding, findAll } from './_utils';

type LinkReceiveMessageData = {
  // update_link() does not drop NULLs, so label may arrive as null.
  label?: string | null;
};

class LinkInputBinding extends NativeEventInputBinding {
  override find(scope: HTMLElement): JQuery<HTMLElement> {
    return findAll(scope, '.bsides-input-link');
  }

  override getValue(el: HTMLElement): number {
    return Number(el.dataset.bsidesClicks) || 0;
  }

  // Matches the input handler registered by the R side.
  override getType(el: HTMLElement): string | null {
    void el;
    return 'bsides.link';
  }

  override subscribe(
    el: HTMLElement,
    callback: (allowDeferred: boolean) => void,
  ): void {
    this.listen(el, 'click', () => {
      el.dataset.bsidesClicks = String(this.getValue(el) + 1);
      callback(false);
    });
  }

  override getState(el: HTMLElement): { value: number } {
    return {
      value: this.getValue(el),
    };
  }

  override receiveMessage(el: HTMLElement, data: LinkReceiveMessageData): void {
    if (data.label != null) {
      el.innerHTML = data.label;
    }
  }
}

registerBinding(LinkInputBinding, 'link');

export { LinkInputBinding };
export type { LinkReceiveMessageData };
