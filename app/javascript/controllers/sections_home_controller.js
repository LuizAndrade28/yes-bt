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

    // Change color selected
    const allMenuOptions = document.querySelectorAll('.m-op');
    allMenuOptions.forEach((opt) => {
      opt.style.backgroundColor = '#f4f4f4';
      opt.style.color = '#0E0000';
    });
    element.target.style.backgroundColor = '#e09942';
    element.target.style.color = '#f4f4f4';

    // Show the selected option
    const swap = document.querySelector(`#option-${element.target.dataset.value}`);
    swap.classList.remove('d-none');
  }
}
