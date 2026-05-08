import { Controller } from "@hotwired/stimulus";
import { Tooltip } from "bootstrap";

// Controller to copy text from source into clipboard.
export default class extends Controller {
    static targets = [ "source", "button" ]

    connect() {
        this.tooltip = new Tooltip(this.buttonTarget, { title: 'Copied!', trigger: 'manual' });
    }

    disconnect() {
        this.tooltip?.dispose();
    }

    copy() {
        // Copy text.
        navigator.clipboard.writeText(this.sourceTarget.text);

        // Show tooltip to let users know value has been copied.
        this.tooltip.show();

        // Hide tooltip after a few seconds.
        setTimeout(() => {
            this.tooltip.hide();
        }, 3000);
    }
}
