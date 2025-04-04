import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="review"
export default class extends Controller {
  static targets = ["anonymous", "score", "comment", "form"]

  edit(event) {
    event.preventDefault();

    let review = event.currentTarget.dataset;

    this.anonymousTarget.value = review.anonymous;
    this.scoreTarget.value = review.score;
    this.commentTarget.value = review.comment;

    this.formTarget.scrollIntoView({behavior: "smooth", block: "center"});
    this.commentTarget.focus();
  }
}
