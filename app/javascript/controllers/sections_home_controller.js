import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sections-home"
export default class extends Controller {
  connect() {
  }

  show(element) {
    // Select all options
    const all = document.querySelectorAll('.option');

    // Hide all options
    all.forEach((opt) => {
      opt.classList.add('d-none');
    });

    // Show the selected option
    const swap = document.querySelector(`#option-${element.target.dataset.value}`);
    swap.classList.remove('d-none');
  }
}
