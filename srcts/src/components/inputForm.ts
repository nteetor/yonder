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
        event.preventDefault();

        for (const [key, value] of inputValues.entries()) {
          Shiny?.setInputValue?.(key, value, { priority: 'event' });
        }

        formValues.set(el, (submit as HTMLButtonElement).value);
        callback(false);
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

registerBinding(FormInputBinding, 'form');

export { FormInputBinding };
export type { FormReceiveMessageData };
