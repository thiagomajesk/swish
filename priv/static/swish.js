var LiveView = (() => {
  var __defProp = Object.defineProperty;
  var __markAsModule = (target) => __defProp(target, "__esModule", { value: true });
  var __export = (target, all) => {
    __markAsModule(target);
    for (var name in all)
      __defProp(target, name, { get: all[name], enumerable: true });
  };

  // index.js
  var assets_exports = {};
  __export(assets_exports, {
    default: () => assets_default
  });

  // utils/attribute.js
  function getAttributeOrThrow(element, attr, transform = null) {
    if (!element.hasAttribute(attr)) {
      throw new Error(`Missing attribute '${attr}' on element <${element.tagName}:${element.id}>`);
    }
    const value = element.getAttribute(attr);
    return transform ? transform(value) : value;
  }
  function parseInteger(value) {
    const number = parseInt(value, 10);
    if (Number.isNaN(number)) {
      throw new Error(`Invalid integer value ${value}`);
    }
    return number;
  }

  // hooks/portal.js
  var events = Object.keys(window).filter((k) => /\bon/.test(k));
  function forwardEvents(template, portal) {
    for (const event of events) {
      portal.addEventListener(event, (e) => {
        e.stopPropagation();
        template.dispatchEvent(new e.constructor(e.type, e));
      });
    }
  }
  var updates = {
    "prepend": (target, clone) => {
      target.parentNode.insertBefore(clone, target);
    },
    "append": (target, clone) => {
      target.parentNode.insertBefore(clone, target.nextSibling);
    },
    "origin": (target, clone) => {
      target.appendChild(clone);
    }
  };
  var portal_default = {
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
      clearTimeout(this.closeTimeout);
    },
    handleOpen() {
      this.clone = this.el.content.cloneNode(true).firstElementChild;
      updates[this.update](this.target, this.clone);
      forwardEvents(this.el, this.clone);
    },
    handleClose() {
      const clone = this.clone;
      this.closeTimeout = setTimeout(() => clone.remove(), this.closeDelay);
    }
  };

  // hooks/toast.js
  var toast_default = {
    closeDelay: null,
    closeTimeout: null,
    mounted() {
      console.log("swish mounted");
      this.closeDelay = getAttributeOrThrow(this.el, "data-close-delay", parseInteger);
      setTimeout(() => {
        this.el.remove();
      }, this.closeDelay);
    },
    destroyed() {
      clearTimeout(this.closeTimeout);
    }
  };

  // hooks/index.js
  var hooks_default = {
    "Swish.Portal": portal_default,
    "Swish.Toast": toast_default
  };

  // index.js
  var assets_default = {
    Hooks: hooks_default
  };
  return assets_exports;
})();
