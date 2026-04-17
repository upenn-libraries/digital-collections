import { createElement } from "react";
import { createRoot } from "react-dom/client";
import ViewerSkeleton from "@components/viewer_skeleton/ViewerSkeleton";
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
    return createElement(ViewerSkeleton, { manifestUrl: this.urlValue });
  }
}
