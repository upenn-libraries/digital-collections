import { createElement } from "react";
import { createRoot } from "react-dom/client";
import DigitalCollectionsViewer from "@components/DigitalCollectionsViewer/DigitalCollectionsViewer";
import { Controller } from "@hotwired/stimulus";

export default class CloverViewerController extends Controller {
  static values = {
    url: String,
  };

  connect() {
    const root = createRoot(this.element);
    const viewer = this.getViewer();
    root.render(viewer);
  }

  getViewer() {
    return createElement(DigitalCollectionsViewer, { manifestUrl: this.urlValue });
  }
}
