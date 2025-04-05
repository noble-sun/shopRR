import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="product"
export default class extends Controller {
  static targets = ["quantity", "mainImage"]

  decrement() {
    let count = parseInt(this.quantityTarget.value) - 1;
    this.quantityTarget.value = count < 1 ? 0 : count;
  }

  decrementInCart() {
    let count = parseInt(this.quantityTarget.value) - 1;
    this.quantityTarget.value = count < 1 ? 1 : count;
  }

  increment() {
    this.quantityTarget.value = parseInt(this.quantityTarget.value) + 1;
  }

  changeImage(event) {
    this.mainImageTarget.src = event.currentTarget.dataset.productImageUrl;
  }
}
