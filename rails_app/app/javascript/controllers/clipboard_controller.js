import { Controller } from "@hotwired/stimulus";

// Controller to copy text from link into clipboard.
export default class extends Controller {
    static targets = [ "source" ]

    copy() {
        navigator.clipboard.writeText(this.sourceTarget.text)
    }
}
