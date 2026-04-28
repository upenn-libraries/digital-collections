import React from "react";

// Clover-IIIF Viewer
import Viewer from "@samvera/clover-iiif/viewer";

// Table of Contents components
import EntriesPanel from "./EntriesPanel";
import MoreInfoButton from "./MoreInfoButton";

// Viewer asset download component
import DownloadButton from "./DownloadButton";

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
         * All must contrast to 4.5 or greater with `primary` and  `accent`.
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

const options = {
    showTitle: false,
    showDownload: false,
    showIIIFBadge: false,
    informationPanel: {
        open: false,
        renderToggle: false,
        renderAnnotation: false,
        defaultTab: 'manifest-about'
    },
};

const ASSET_ID_KEY = 'asset-id';

// Build content state json, if assetId is present in manifest.
const buildIIIFContentState = (manifest, assetId) => {
    // Get canvas.
    const canvas = assetId && manifest.items.find((item) => item?.id.includes(assetId));

    // Return if canvas not present return null, otherwise return content state with selected canvas.
    return canvas ? {
        "@context": "http://iiif.io/api/presentation/3/context.json",
        id: `${manifest.id}/state/1`,
        type: "Annotation",
        motivation: ["contentState"],
        target: {
            type: "SpecificResource",
            source: {
                id: canvas.id,
                type: "Canvas",
                partOf: [
                    {
                        id: manifest.id,
                        type: "Manifest",
                    },
                ],
            },
        }
    } : null;
}

export default function IIIFViewer({ manifest }) {
    const plugins = manifest.structures?.length > 0 ? [downloadPlugin, contentsPlugin] : [downloadPlugin];

    const urlAssetId = new URL(window.location.href).searchParams.get(ASSET_ID_KEY);

    const iiifContent = buildIIIFContentState(manifest, urlAssetId);

    const firstCanvasId = manifest.items.at(0).id;

    // The canvasIdCallback is called accurately when a user is clicking on two pages that are side-by-side, while
    // contentStateCallback does not differentiate between the side-by-side pages.
    const handleCanvasIdCallback = (activeCanvasId) => {
        if (!activeCanvasId) return;

        const match = activeCanvasId.match(/assets\/(.+)\/canvas$/);

        if (!match) throw new Error(`Unexpected canvas ID format: ${activeCanvasId}`);

        const assetId = match[1];

        const url = new URL(window.location.href);

        // If selected canvas is the first one, then remove asset-id param.
        // If selected canvas is different from the value of asset-id, update asset-id.
        if (firstCanvasId.includes(assetId)) {
            url.searchParams.delete(ASSET_ID_KEY);
            history.replaceState(null, '', url);
        } else if (url.searchParams.get(ASSET_ID_KEY) !== assetId) {
            url.searchParams.set(ASSET_ID_KEY, assetId);
            history.replaceState(null, '', url);
        }
    };

    return (
        <Viewer iiifContent={iiifContent || manifest}
                options={options}
                plugins={plugins}
                customTheme={customTheme}
                canvasIdCallback={handleCanvasIdCallback} />
    );
}