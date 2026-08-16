import { NativeEventInputBinding, findAll, registerBinding } from './_utils';
import './webcomponents/file';
import type { BsidesFile, FileUpdate } from './webcomponents/file';

// Thin adapter over <bsides-file>: the element owns the picker, the file
// list, and the upload lifecycle; the binding only relays server messages.
//
// No value flows through here. Shiny's upload protocol ends with the
// server setting input$<id> from the finalized temp files, so the binding
// only has to answer bind-time questions the way the stock file input
// does — a null value of type "shiny.file", whose R-side handler maps
// NULL to NULL. The consequence is the stock one too: re-rendering the
// input resets input$<id> to NULL.
class FileInputBinding extends NativeEventInputBinding {
  override find(scope: HTMLElement): JQuery<HTMLElement> {
    return findAll(scope, 'bsides-file');
  }

  override getValue(el: HTMLElement): null {
    void el;
    return null;
  }

  override getType(el: HTMLElement): string | null {
    void el;
    return 'shiny.file';
  }

  // Nothing to subscribe to: uploads reach the server over HTTP and are
  // announced by the protocol's uploadEnd, not by an input change.
  override subscribe(
    el: HTMLElement,
    callback: (allowDeferred: boolean) => void,
  ): void {
    void el;
    void callback;
  }

  // All state changes live in the component; the binding only forwards.
  override receiveMessage(el: HTMLElement, data: FileUpdate): void {
    (el as BsidesFile).receiveUpdate(data);
  }
}

registerBinding(FileInputBinding, 'file');

export { FileInputBinding };
