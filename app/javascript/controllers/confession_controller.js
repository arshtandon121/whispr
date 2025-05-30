import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["reactionButton", "reactions", "likeEmoji", "hugEmoji", "laughEmoji", "likeCount", "hugCount", "laughCount"]
  static values = {
    confessionId: String,
    hasReacted: Boolean
  }

  connect() {
    // Add event listeners for all reaction buttons
    this.reactionButtonTargets.forEach(button => {
      button.addEventListener("turbo:submit-start", this.handleSubmitStart.bind(this))
      button.addEventListener("turbo:submit-end", this.handleSubmitEnd.bind(this))
      button.addEventListener("turbo:before-fetch-response", this.handleBeforeFetchResponse.bind(this))
    })
  }

  disconnect() {
    // Clean up event listeners
    this.reactionButtonTargets.forEach(button => {
      button.removeEventListener("turbo:submit-start", this.handleSubmitStart.bind(this))
      button.removeEventListener("turbo:submit-end", this.handleSubmitEnd.bind(this))
      button.removeEventListener("turbo:before-fetch-response", this.handleBeforeFetchResponse.bind(this))
    })
  }

  async react(event) {
    event.preventDefault()
    const button = event.currentTarget
    const type = button.dataset.type

    // Check reaction status in real-time
    try {
      const response = await fetch(`/confessions/${this.confessionIdValue}/check_reaction`, {
        headers: {
          'Accept': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        }
      })
      const data = await response.json()

      if (data.has_reacted) {
        this.showError("You can only react once to each confession.")
        return
      }

      // If not reacted, proceed with the reaction
      this.handleReaction(button, type)
    } catch (error) {
      console.error('Error checking reaction status:', error)
      this.showError("Unable to process your reaction. Please try again.")
    }
  }

  handleReaction(button, type) {
    // Add animation class to emoji
    const emoji = this[`${type}EmojiTarget`]
    emoji.classList.add("scale-150")
    setTimeout(() => {
      emoji.classList.remove("scale-150")
    }, 200)

    // Optimistically update the count
    const count = this[`${type}CountTarget`]
    const currentCount = parseInt(count.textContent)
    count.textContent = currentCount + 1
    count.classList.add("text-indigo-600", "font-semibold")
    setTimeout(() => {
      count.classList.remove("text-indigo-600", "font-semibold")
    }, 1000)

    // Submit the form
    const form = button.closest("form")
    form.requestSubmit()
  }

  showError(message) {
    // Create flash message element
    const flashContainer = document.getElementById("flash_messages")
    const flashDiv = document.createElement("div")
    flashDiv.className = "rounded-lg p-4 shadow-sm ring-1 transition-all duration-300 transform translate-y-0 opacity-100 bg-red-50 ring-red-100"
    flashDiv.innerHTML = `
      <div class="flex items-center">
        <div class="flex-shrink-0">
          <svg class="h-5 w-5 text-red-400" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
          </svg>
        </div>
        <div class="ml-3">
          <p class="text-sm font-medium text-red-800">${message}</p>
        </div>
        <div class="ml-auto pl-3">
          <button type="button" class="inline-flex rounded-md p-1.5 text-red-500 hover:bg-red-100 focus:outline-none focus:ring-2 focus:ring-red-600 focus:ring-offset-2" data-action="click->flash#dismiss">
            <span class="sr-only">Dismiss</span>
            <svg class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
            </svg>
          </button>
        </div>
      </div>
    `

    // Add to flash container
    flashContainer.appendChild(flashDiv)

    // Auto-dismiss after 5 seconds
    setTimeout(() => {
      flashDiv.classList.add("opacity-0", "-translate-y-2")
      setTimeout(() => flashDiv.remove(), 300)
    }, 5000)
  }

  handleSubmitStart(event) {
    const button = event.target
    const type = button.dataset.type
    const emoji = this[`${type}EmojiTarget`]
    
    // Disable the button and show loading state
    button.disabled = true
    emoji.classList.add("opacity-50")
  }

  handleSubmitEnd(event) {
    const button = event.target
    const type = button.dataset.type
    const emoji = this[`${type}EmojiTarget`]
    
    // Re-enable the button and remove loading state
    button.disabled = false
    emoji.classList.remove("opacity-50")

    // If successful, mark as reacted
    if (event.detail.fetchResponse.ok) {
      this.hasReactedValue = true
    }
  }

  handleBeforeFetchResponse(event) {
    const response = event.detail.fetchResponse
    if (!response.ok) {
      // If the request failed, revert the optimistic update
      const button = event.target
      const type = button.dataset.type
      const count = this[`${type}CountTarget`]
      
      // Revert the count
      const currentCount = parseInt(count.textContent)
      count.textContent = currentCount - 1
      
      // Remove any animation classes
      count.classList.remove("text-indigo-600", "font-semibold")
    }
  }
} 