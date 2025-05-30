import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener("turbo:before-stream-render", this.handleBeforeStreamRender.bind(this))
  }

  disconnect() {
    this.element.removeEventListener("turbo:before-stream-render", this.handleBeforeStreamRender.bind(this))
  }

  handleBeforeStreamRender(event) {
    const fragment = event.detail.newStream
    const animatedElements = fragment.querySelectorAll("[data-turbo-animate]")

    animatedElements.forEach(element => {
      const classes = element.dataset.turboAnimate.split(" ")
      element.classList.add(...classes)

      // Remove animation classes after animation completes
      setTimeout(() => {
        element.classList.remove(...classes)
      }, 1000)
    })
  }
} 