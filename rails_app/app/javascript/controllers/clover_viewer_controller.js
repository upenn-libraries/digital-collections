import { createElement } from "react";
import { createRoot } from "react-dom/client";
import DigitalCollectionsViewer from "@components/DigitalCollectionsViewer/DigitalCollectionsViewer";
import { Controller } from "@hotwired/stimulus";

export default class CloverViewerController extends Controller {
  static targets = ["mount"];

  static values = {
    url: String,
    simulate: String,
  };

  connect() {
    this.attempt = 0;

    if (this.simulateValue) {
      this.setViewerState(this.simulateValue);
    } else {
      this.mount();
    }
  }

  disconnect() {
    const root = this.root;
    this.root = null;

    if (root) queueMicrotask(() => root.unmount());
  }

  retry() {
    this.attempt += 1;
    this.mount();
  }

  mount() {
    try {
      if (!this.root) {
        this.mountTarget.replaceChildren();
        this.root = createRoot(this.mountTarget);
      }

      this.root.render(createElement(DigitalCollectionsViewer, {
        manifestUrl: this.urlValue,
        retryToken: this.attempt,
        onStateChange: this.setViewerState,
      }));
    } catch (error) {
      console.error("[clover-viewer] Could not mount the viewer", error);
      this.setViewerState("error");
    }
  }

  setViewerState = (state) => {
    this.element.dataset.viewerState = state;
  };
}
