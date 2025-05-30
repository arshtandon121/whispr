import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Start auto-dismiss timer when connected
    this.startAutoDismiss()
  }

  dismiss() {
    this.element.classList.add("opacity-0", "-translate-y-2")
    setTimeout(() => this.element.remove(), 300)
  }

  remove(event) {
    if (event.animationName === "fade-out") {
      this.element.remove()
    }
  }

  startAutoDismiss() {
    setTimeout(() => {
      this.dismiss()
    }, 5000)
  }
} 