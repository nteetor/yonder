import { Collapse } from 'bootstrap';

import { NativeEventInputBinding, registerBinding, findAll } from './_utils';

type CollapseReceiveMessageData = {
  method?: string;
};

// Bootstrap's Collapse defaults to `toggle: true`, and its constructor calls
// toggle() when that is set. Creating an instance with the defaults would
// flip the panel as a side effect of the first server message, so every
// lookup passes `toggle: false` — as Bootstrap's own data-api does.
function instance(el: HTMLElement): Collapse {
  return Collapse.getOrCreateInstance(el, { toggle: false });
}

// Every trigger currently on the page whose target resolves to this panel.
//
// Collapse caches its trigger list at construction and updates only those.
// collapse_panel_button() renders a tag separate from the panel, so a trigger
// added by renderUI() after the panel was bound is invisible to the instance
// and would keep stale state; querying at state-change time always sees the
// current set.
function triggersFor(panel: HTMLElement): HTMLElement[] {
  const triggers = document.querySelectorAll<HTMLElement>(
    '[data-bs-toggle="collapse"]',
  );

  return [...triggers].filter((trigger) => {
    const selector =
      trigger.getAttribute('data-bs-target') ?? trigger.getAttribute('href');

    if (!selector) {
      return false;
    }

    // Bootstrap resolves a trigger the same way, but its SelectorEngine is
    // not exported from the package entry. An href such as "https://…" is a
    // valid href and an invalid selector, so matches() throws on it.
    try {
      return panel.matches(selector);
    } catch {
      return false;
    }
  });
}

function syncTriggers(panel: HTMLElement): void {
  const open = panel.classList.contains('show');

  for (const trigger of triggersFor(panel)) {
    trigger.setAttribute('aria-expanded', String(open));
    trigger.classList.toggle('collapsed', !open);
  }
}

class CollapseInputBinding extends NativeEventInputBinding {
  override find(scope: HTMLElement): JQuery<HTMLElement> {
    return findAll(scope, '.bsides-collapse');
  }

  // Shiny calls this once per bind, before the first getValue(). Syncing here
  // also corrects the initial state: collapse_panel_button() hardcodes
  // aria-expanded="false", so a panel created with state = "open" ships a
  // trigger that contradicts it.
  override initialize(el: HTMLElement): void {
    syncTriggers(el);
  }

  // Bootstrap removes .show at the start of a hide and adds it at the end of
  // a show, so this reads "closed" for the whole of both transitions. Every
  // caller — bind, and the shown/hidden handlers — reads at a resting state.
  // Consulting .collapsing instead would report mid-transition states the
  // spec does not report.
  override getValue(el: HTMLElement): string {
    return el.classList.contains('show') ? 'open' : 'closed';
  }

  override subscribe(
    el: HTMLElement,
    callback: (allowDeferred: boolean) => void,
  ): void {
    // Bootstrap dispatches native events whose type is the full dotted name,
    // both after the CSS transition completes. Trigger clicks belong to
    // Bootstrap's data-api; handling them here as well would toggle twice.
    this.listen(el, 'shown.bs.collapse', () => {
      syncTriggers(el);
      callback(false);
    });

    this.listen(el, 'hidden.bs.collapse', () => {
      syncTriggers(el);
      callback(false);
    });
  }

  override getState(el: HTMLElement): { value: string } {
    return {
      value: this.getValue(el),
    };
  }

  override receiveMessage(
    el: HTMLElement,
    data: CollapseReceiveMessageData,
  ): void {
    // show() and hide() already no-op when the panel is in the requested
    // state, and all three no-op mid-transition, so no extra guarding.
    // No announce(): Bootstrap's own events drive the subscription, and a
    // synthetic change would double-report.
    switch (data.method) {
      case 'open':
        instance(el).show();
        break;

      case 'close':
        instance(el).hide();
        break;

      case 'toggle':
        instance(el).toggle();
        break;
    }
  }

  override unsubscribe(el: HTMLElement): void {
    super.unsubscribe(el);

    // dispose() drops Bootstrap's bs.collapse entry for the element.
    // Without it a panel removed by removeUI() leaves a live instance
    // pointing at a detached element, and a later panel with the same id
    // picks up the stale state. getInstance(), not getOrCreateInstance(), so
    // tearing down a never-messaged panel does not build one to destroy it.
    Collapse.getInstance(el)?.dispose();
  }
}

registerBinding(CollapseInputBinding, 'collapse');

export { CollapseInputBinding };
export type { CollapseReceiveMessageData };
