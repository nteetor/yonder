import {
  NativeEventInputBinding,
  registerBinding,
  findAll,
  hasDefinedProperty,
  Shiny,
} from './_utils';

type FormReceiveMessageData = {
  submit?: string;
};

// Passed on the bsides-form:submit event. A nested component with work
// that must finish before the form's values may go — a staged file
// input, whose upload sets its value server-side — hands that work back
// through waitUntil(), after ExtendableEvent. An internal protocol
// between this binding and <bsides-file>; nothing else speaks it.
type FormSubmitDetail = {
  waitUntil: (blocker: Promise<unknown>) => void;
};

const formValues = new WeakMap<HTMLElement, string>();

// A form freezes the inputs it contains: child input changes are held back
// (event.preventDefault() on shiny:inputchanged) and replayed to the server
// only when a submit button is clicked.
//
// Shiny triggers shiny:inputchanged as a jQuery event and honors
// preventDefault() only on that object, so it must be observed through
// the page's jQuery — no native listener can intercept it.
class FormInputBinding extends NativeEventInputBinding {
  override find(scope: HTMLElement): JQuery<HTMLElement> {
    return findAll(scope, '.bsides-input-form');
  }

  override getValue(el: HTMLElement): unknown {
    return formValues.get(el);
  }

  override subscribe(
    el: HTMLElement,
    callback: (allowDeferred: boolean) => void,
  ): void {
    const inputValues = new Map<string, unknown>();

    window
      .jQuery?.(el)
      .on('shiny:inputchanged.bsidesFormInputBinding', (event) => {
        const inputEvent = event as unknown as ShinyInputChangedEvent;

        // Load-bearing: Shiny.setInputValue() pushes carry no element,
        // and they must pass — the file input's __bsides_* state
        // companions ride that path, staged-set state included, from
        // file inputs nested in this very form.
        if (!inputEvent.el || inputEvent.priority === 'event') {
          return;
        }

        // Hold back inputs inside the form, but not the form's own value —
        // el.contains(el) is true, and intercepting ourselves would freeze
        // the submit value forever.
        if (inputEvent.el !== el && el.contains(inputEvent.el)) {
          const name = inputEvent.inputType
            ? `${inputEvent.name}:${inputEvent.inputType}`
            : inputEvent.name;

          inputValues.set(name, inputEvent.value);
          inputEvent.preventDefault();
        }
      });

    this.listenDelegated(
      el,
      'click',
      '.bsides-input-form-submit',
      (event, submit) => {
        // Synchronous, and first: an await ahead of this would let the
        // browser perform a native form submission.
        event.preventDefault();

        const button = submit as HTMLButtonElement;
        const blockers: Promise<unknown>[] = [];

        // Ask nested components what must finish first. A staged file
        // input starts its batch here and hands back that batch, so its
        // uploadEnd — which is what sets its value, server-side —
        // completes before the form's own value is sent. Reached by the
        // server-driven path too: receiveMessage() below clicks the
        // matching button, which lands in this handler.
        el.dispatchEvent(
          new CustomEvent('bsides-form:submit', {
            bubbles: true,
            detail: {
              waitUntil: (blocker: Promise<unknown>) => {
                blockers.push(blocker);
              },
            } satisfies FormSubmitDetail,
          }),
        );

        const send = (): void => {
          for (const [key, value] of inputValues.entries()) {
            Shiny?.setInputValue?.(key, value, { priority: 'event' });
          }

          formValues.set(el, button.value);
          callback(false);
        };

        // Nothing to wait for: stay synchronous rather than deferring a
        // microtask on every form in the package to serve the one case
        // that needs it.
        if (blockers.length === 0) {
          send();
          return;
        }

        const release = holdSubmits(el, button);

        void Promise.all(blockers).then(
          () => {
            release();
            send();
          },
          () => {
            // A blocker failed or the user cancelled it, so the form's
            // premise — that this work is part of the submission — no
            // longer holds and nothing is sent. inputValues is never
            // cleared, so every frozen value stays queued for the next
            // attempt.
            release();
          },
        );
      },
    );
  }

  override unsubscribe(el: HTMLElement): void {
    super.unsubscribe(el);
    window.jQuery?.(el).off('.bsidesFormInputBinding');
  }

  override receiveMessage(el: HTMLElement, data: FormReceiveMessageData): void {
    if (hasDefinedProperty(data, 'submit')) {
      const submits = el.querySelectorAll<HTMLButtonElement>(
        '.bsides-input-form-submit',
      );

      [...submits].find((submit) => submit.value === data.submit)?.click();
    }
  }
}

// A form waiting on a blocker reads as a broken form unless it says so.
// The clicked button carries the pending state; every submit in the form
// is disabled so a second click cannot race the first. Only the buttons
// this actually disabled are restored — an app may have disabled one of
// its own.
function holdSubmits(el: HTMLElement, button: HTMLButtonElement): () => void {
  const held = [
    ...el.querySelectorAll<HTMLButtonElement>('.bsides-input-form-submit'),
  ].filter((other) => !other.disabled);

  for (const other of held) {
    other.disabled = true;
  }

  button.classList.add('pending');
  button.setAttribute('aria-busy', 'true');

  return () => {
    for (const other of held) {
      other.disabled = false;
    }

    button.classList.remove('pending');
    button.removeAttribute('aria-busy');
  };
}

registerBinding(FormInputBinding, 'form');

declare global {
  interface GlobalEventHandlersEventMap {
    'bsides-form:submit': CustomEvent<FormSubmitDetail>;
  }
}

export { FormInputBinding };
export type { FormReceiveMessageData, FormSubmitDetail };
