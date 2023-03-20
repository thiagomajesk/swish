import { getAttributeOrThrow, parseInteger } from "../utils/attribute"

/**
 * A hook used to create a Portal in the DOM.
 * 
 * Portals give us the ability to render components outside the DOM hierarchy of their parent components. 
 * This can be achieved using techniques such as creating a new HTML element outside the normal DOM hierarchy.
 * It also facilitates the placement of positioned that can be styled without being constrained by their parent components. 
 * In essence, it allows the developers to create more flexible and powerful user interfaces, such as modal dialogs, tooltips, and popovers.
 * 
 * ## Configuration
 * 
 *  * `data-update` - the operation to be executed, it can be either: origin (default), append or prepend.
 *  * `data-target` - the DOM element where the portal is going to be placed. 
 *  * `data-destroy-delay` - delay to remove teleported elements in ms after closing the portal
 */

// Cache a list of possible DOM events that we want to forward
const events = Object.keys(window).filter((k) => /\bon/.test(k))

function forwardEvents(template, portal) {
  for (const event of events) {
    portal.addEventListener(event, e => {
      e.stopPropagation();
      template.dispatchEvent(new e.constructor(e.type, e));
    });
  }
}

const updates = {
  "prepend": (target, clone) => {
    target.parentNode.insertBefore(clone, target)
  },
  "append": (target, clone) => {
    target.parentNode.insertBefore(clone, target.nextSibling)
  },
  "origin": (target, clone) => {
    target.appendChild(clone)
  }
}

export default {
  clone: null,
  target: null,
  update: null,
  eventsTimeout: null,
  destroyTimeout: null,
  destroyDelay: null,

  mounted() {
    const targetSelector = getAttributeOrThrow(this.el, "data-target");

    this.target = document.querySelector(targetSelector);
    this.update = getAttributeOrThrow(this.el, "data-update");
    this.destroyDelay = getAttributeOrThrow(this.el, "data-destroy-delay", parseInteger);

    this.el.addEventListener("portal:open", this.handleOpen.bind(this));
    this.el.addEventListener("portal:close", this.handleClose.bind(this));
  },

  destroyed() {
    this.clone.remove();

    // Removes the timeouts just to be sure 
    clearTimeout(this.eventsTimeout);
    clearTimeout(this.destroyTimeout);
  },

  handleOpen() {
    let clone = this.el.content.cloneNode(true);
    this.clone = clone.firstElementChild;

    // Teleports clone to target
    updates[this.update](this.target, this.clone)

    // Await until next tick to register the forwarded events
    this.eventsTimeout = setTimeout(() => forwardEvents(this.el, this.clone), 0)
  },

  handleClose() {
    // Cache old clone to avoid race conditions
    let clone = this.clone

    // Await a little before removing the element so animations can be properly displayed. 
    // Ideally this shoud be configurable in the future so the user has more control over it.
    this.destroyTimeout = setTimeout(() => clone.remove(), this.destroyDelay);
  }
}
