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
 *  * `data-close-delay` - delay in ms to close the open portal.
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
  closeDelay: null,
  closeTimeout: null,

  mounted() {
    const targetSelector = getAttributeOrThrow(this.el, "data-target");

    this.target = document.querySelector(targetSelector);
    this.update = getAttributeOrThrow(this.el, "data-update");
    this.closeDelay = getAttributeOrThrow(this.el, "data-close-delay", parseInteger);

    this.el.addEventListener("portal:open", this.handleOpen.bind(this));
    this.el.addEventListener("portal:close", this.handleClose.bind(this));
  },

  destroyed() {
    this.clone.remove();

    // Removes the timeouts just to be sure 
    clearTimeout(this.closeTimeout);
  },

  handleOpen() {
    this.clone = this.el.content.cloneNode(true).firstElementChild;

    // Opens the portal and teleports clone to target.
    // Await a little before opening so animation ca be properly displayed.
    updates[this.update](this.target, this.clone);

    // Await until next tick to register the forwarded events
    forwardEvents(this.el, this.clone)
  },

  handleClose() {
    // Cache old clone to avoid race conditions
    const clone = this.clone

    // Closes the portal and removes the cloned element.
    // Await a little before closing so animations can be properly displayed. 
    this.closeTimeout = setTimeout(() => clone.remove(), this.closeDelay);
  },
}
