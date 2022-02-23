import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Hello RITA!");
    alert("Console has been updated.");
    alert("Hello World!")
  }
}
