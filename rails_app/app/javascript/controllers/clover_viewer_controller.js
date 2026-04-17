import { createElement } from "react";
import { createRoot } from "react-dom/client";
import Viewer from "@samvera/clover-iiif/viewer";
import { Controller } from "@hotwired/stimulus";
import { decodeContentState } from "@iiif/helpers";

// Table of Contents components
import EntriesPanel from "@components/table_of_contents/EntriesPanel";
import MoreInfoButton from "@components/table_of_contents/MoreInfoButton";

// Viewer asset download component
import DownloadButton from "@components/media_download/DownloadButton";

const options = {
  showTitle: false,
  showDownload: false,
  showIIIFBadge: false,
  informationPanel: {
    open: false,
    renderToggle: false,
  },
  openSeadragon: {
    gestureSettingsMouse: {
      scrollToZoom: false,
    },
  },
  canvasHeight: "640px"
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
    label: { none: ["Table of contents"] },
  },
};

const downloadPlugin = {
  id: "download-button",
  imageViewer: {
    controls: {
      component: DownloadButton,
    },
  },
};

const customTheme = {
  colors: {
    /**
     * Black and dark grays in a light theme.
     * All must contrast to 4.5 or greater with `secondary`.
     */
    primary: "#2D3545",
    primaryMuted: "#595F6A",
    primaryAlt: "#2D3545",

    /**
     * Key brand color(s).
     * `accent` must contrast to 4.5 or greater with `secondary`.
     */
    accent: "#0E5696",
    accentMuted: "#0E5696",
    accentAlt: "#0E5696",

    /**
     * White and light grays in a light theme.
     * All must must contrast to 4.5 or greater with `primary` and  `accent`.
     */
    secondary: "#FFFFFF",
    secondaryMuted: "#F5F5F6",
    secondaryAlt: "#F5F5F6",
  },
  fonts: {
    sans: "proxima-nova, system-ui, sans-serif",
    display: "proxima-nova, system-ui, sans-serif",
  },
};

const handleContentStateCallback = ({ encoded, json }) => {
  console.log({
    encoded, // base64 encoded JSON
    json, // raw JSON
  });

  const url = new URL(window.location.href);
  url.searchParams.set('iiif-content', encoded);
  history.replaceState(null, '', url);
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
    const params = new URL(window.location.href).searchParams;

    let iiifContent = manifest;

    // If `iiif-content` query parameter present use that instead of the manifest.
    // TOOD: Ensure the `iiif-content` provided is for the manifest on this page.
    if (params.has('iiif-content')) {
      const iiifContentEncoded = params.get('iiif-content');
      iiifContent = JSON.parse(decodeContentState(iiifContentEncoded));
      console.log('Content state from url: ');
      console.log(iiifContent);
    }

    return createElement(Viewer, {
      iiifContent: iiifContent,
      options: options,
      plugins: hasStructures
        ? [downloadPlugin, contentsPlugin]
        : [downloadPlugin],
      customTheme: customTheme,
      contentStateCallback: handleContentStateCallback,
    });
  }
}
