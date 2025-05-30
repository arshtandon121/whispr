import { Controller } from "@hotwired/stimulus"
import Swal from "sweetalert2"

export default class extends Controller {
  static targets = ["body", "submit"]

  connect() {
    this.element.addEventListener("turbo:submit-start", this.handleSubmitStart.bind(this))
    this.element.addEventListener("turbo:submit-end", this.handleSubmitEnd.bind(this))
    this.element.addEventListener("turbo:before-fetch-response", this.handleBeforeFetchResponse.bind(this))
  }

  disconnect() {
    this.element.removeEventListener("turbo:submit-start", this.handleSubmitStart.bind(this))
    this.element.removeEventListener("turbo:submit-end", this.handleSubmitEnd.bind(this))
    this.element.removeEventListener("turbo:before-fetch-response", this.handleBeforeFetchResponse.bind(this))
  }

  validate() {
    const body = this.bodyTarget.value.trim()
    this.submitTarget.disabled = body.length === 0
  }

  submit(event) {
    this.validate()
    if (this.submitTarget.disabled) {
      event.preventDefault()
      Swal.fire({
        title: 'Error!',
        text: 'Please enter a confession before submitting.',
        icon: 'error',
        confirmButtonText: 'OK'
      })
    }
  }

  handleSubmitStart(event) {
    this.submitTarget.disabled = true
    this.submitTarget.classList.add("opacity-50", "cursor-not-allowed")
  }

  handleSubmitEnd(event) {
    const response = event.detail.fetchResponse
    this.submitTarget.disabled = false
    this.submitTarget.classList.remove("opacity-50", "cursor-not-allowed")
    
    if (response.ok) {
      this.bodyTarget.value = ""
      this.validate()
    }
  }

  handleBeforeFetchResponse(event) {
    const response = event.detail.fetchResponse
    
    if (!response.ok) {
      event.preventDefault()
      
      if (response.status === 429) {
        this.showErrorMessage('Rate Limited!', 'Please wait a moment before posting again.', 'warning')
      } else {
        try {
          const contentType = response.headers.get('content-type')
          if (contentType && contentType.includes('application/json')) {
            response.json().then(data => {
              this.showErrorMessage('Error!', data.message || 'Something went wrong. Please try again.', 'error')
            }).catch(() => {
              this.showErrorMessage('Error!', 'Something went wrong. Please try again.', 'error')
            })
          } else {
            this.showErrorMessage('Error!', 'Something went wrong. Please try again.', 'error')
          }
        } catch (error) {
          this.showErrorMessage('Error!', 'Something went wrong. Please try again.', 'error')
        }
      }
    } else {
      Swal.fire({
        title: 'Success!',
        text: 'Your confession has been posted.',
        icon: 'success',
        confirmButtonText: 'OK'
      })
    }
  }

  showErrorMessage(title, text, icon) {
    Swal.fire({
      title: title,
      text: text,
      icon: icon,
      confirmButtonText: 'OK'
    })
  }
} 