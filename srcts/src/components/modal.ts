import { Modal as BootstrapModal } from 'bootstrap';

import {
  NativeEventInputBinding,
  registerBinding,
  addCustomMessageHandler,
  findAll,
  Shiny,
} from './_utils';

interface ModalShowMessage {
  modal: string | ShinyRenderContent;
}

class Modal extends BootstrapModal {
  isShown(): boolean {
    return (this as unknown as { _isShown: boolean })._isShown;
  }

  static addMessageHandlers(): void {
    addCustomMessageHandler('modalShow', (data: ModalShowMessage) => {
      if (typeof data.modal === 'object') {
        void Modal.showOrInsertModal(data.modal);
      } else {
        const el = document.getElementById(data.modal);

        if (!el) {
          return;
        }

        const modal = Modal.getOrCreateInstance(el);

        modal.show();
      }
    });

    // Shiny requires message handlers to declare exactly one parameter.
    addCustomMessageHandler('modalClose', (data: unknown) => {
      void data;

      for (const el of document.querySelectorAll('.modal.show')) {
        (Modal.getInstance(el) as Modal | null)?.hide();
      }
    });
  }

  static async showOrInsertModal(content: ShinyRenderContent): Promise<void> {
    const el = document.createElement('div');
    el.innerHTML = content.html;

    const id = el.firstChild && (el.firstChild as HTMLElement).id;

    if (!id || !Shiny) {
      return;
    }

    const existing = document.getElementById(id);

    if (existing) {
      Shiny.unbindAll?.(existing, true);
      existing.remove();
    }

    await Shiny.renderContentAsync(document.body, content, 'beforeEnd');

    const target = document.getElementById(id);

    if (!target) {
      return;
    }

    const modal = new Modal(target);

    modal.show();
  }
}

class ModalInputBinding extends NativeEventInputBinding {
  override find(scope: HTMLElement): JQuery<HTMLElement> {
    return findAll(scope, '.bsides-modal');
  }

  override getValue(el: HTMLElement): string | null {
    const modal = Modal.getInstance(el) as Modal | null;

    if (!modal) {
      return null;
    }

    return modal.isShown() ? 'shown' : 'hidden';
  }

  override subscribe(
    el: HTMLElement,
    callback: (allowDeferred: boolean) => void,
  ): void {
    // Bootstrap dispatches native events whose type is the full dotted
    // name.
    this.listen(el, 'shown.bs.modal', () => {
      callback(false);
    });

    this.listen(el, 'hidden.bs.modal', () => {
      callback(false);
    });
  }
}

Modal.addMessageHandlers();

registerBinding(ModalInputBinding, 'modal');

export { Modal, ModalInputBinding };
export type { ModalShowMessage };
