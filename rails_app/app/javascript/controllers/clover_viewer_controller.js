import { createElement } from "react";
import { createRoot } from "react-dom/client";
import Viewer from "@samvera/clover-iiif/viewer";
import { Controller } from "@hotwired/stimulus";

import EntriesPanel from "@components/table_of_contents/EntriesPanel";
import MoreInfoButton from "@components/table_of_contents/MoreInfoButton";

const options = {
  showTitle: false,
  showDownload: false,
  showIIIFBadge: false,
  informationPanel: {
    open: false,
    renderToggle: false,
  },
};

const contentsPlugin = {
  id: "toc-list",
  imageViewer: {
    controls: {
      component: MoreInfoButton,
    },
  },
  informationPanel: {
    component: EntriesPanel,
    label: { none: ["Table of Contents"] },
  },
};

export default class CloverViewerController extends Controller {
  static values = {
    url: String,
  };

  async connect() {
    const root = createRoot(this.element);
    const viewer = await this.getViewer();
    root.render(viewer);
  }

  async prefetchManifest(url) {
    const response = await fetch(url);
    const manifest = await response.json();
    return manifest;
  }

  async getViewer() {
    const manifest = await this.prefetchManifest(this.urlValue);
    const hasStructures = manifest.structures && manifest.structures.length > 0;

    return createElement(Viewer, {
      iiifContent: manifest,
      options: options,
      plugins: hasStructures ? [contentsPlugin] : [],
    });
  }
}
