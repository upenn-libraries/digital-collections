import { createElement } from "react";
import { createRoot } from "react-dom/client";
import Viewer from "@samvera/clover-iiif/viewer";
import { Controller } from "@hotwired/stimulus";

import TableOfContentsButton from "../components/table_of_contents_button.jsx";

const options = {
  showTitle: false,
  informationPanel: {
    open: false,
  },
};

const contentsPlugin = {
  id: "Demo",
  imageViewer: {
    controls: {
      component: TableOfContentsButton,
    },
  },
};

export default class CloverViewerController extends Controller {
  static values = {
    url: String,
  };

  connect() {
    const root = createRoot(this.element);
    root.render(this.getViewer(this.urlValue));
  }

  getViewer(url) {
    return createElement(Viewer, {
      iiifContent: url,
      options: options,
      plugins: [contentsPlugin],
    });
  }
}
