// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import Swal from "sweetalert2"

// Make Swal available globally
window.Swal = Swal;
