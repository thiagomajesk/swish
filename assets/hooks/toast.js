import { getAttributeOrThrow, parseInteger } from "../utils/attribute"

/**
 * A hook that powers Swish's toasts.
 * 
 * ## Configuration
 * 
 *  * `data-close-delay` - delay in ms to close the toast.
 */

export default {
  closeDelay: null,
  closeTimeout: null,

  mounted() {
    console.log("swish mounted")
    this.closeDelay = getAttributeOrThrow(this.el, "data-close-delay", parseInteger);

    setTimeout(() => {
      this.el.remove();
    }, this.closeDelay)
    
    // TODO: cancel timeout on hover and run it again on hover exit
  },

  destroyed() {
    // Removes the timeouts just to be sure 
    clearTimeout(this.closeTimeout);
  },
}
