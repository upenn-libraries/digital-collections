import React, { useState, useEffect } from "react";

// Placeholder component to render while fetching manifest
import LoadingComponent from "@components/digital_collections_viewer/skeleton/LoadingComponent";

// Clover-IIIF Viewer
import Viewer from "@samvera/clover-iiif/viewer";
// Table of Contents components
import EntriesPanel from "@components/digital_collections_viewer/table_of_contents/EntriesPanel";
import MoreInfoButton from "@components/digital_collections_viewer/table_of_contents/MoreInfoButton";

// Viewer asset download component
import DownloadButton from "@components/digital_collections_viewer/media_download/DownloadButton";

// Viewer configuration

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
    },
};

export default function DigitalCollectionsViewer({ manifestUrl }) {
    const [manifest, setManifest] = useState(null);

    useEffect(() => {
        const fetchManifest = async ()=> {
            const response = await fetch(manifestUrl);
            const json = await response.json();
            setManifest(json);
        }
        fetchManifest();
    }, [manifestUrl]);

    if (!manifest) return <LoadingComponent/>;

    const plugins = manifest.structures?.length > 0 ? [downloadPlugin, contentsPlugin] : [downloadPlugin];

    const params = new URL(window.location.href).searchParams;

    let iiifContent = manifest;

    // If `asset-id` query parameter is present, recreate a content state annotation to
    // move the user to the selected asset canvas.
    if (params.has('asset-id')) {
        // Find canvas in manifest.
        const canvas = manifest.items.find((item) => item?.id.includes(params.get('asset-id')));

        // Create content state hash.
        iiifContent = {
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
        }
    }

    const handleContentStateCallback = ({ encoded, json }) => {
        const firstCanvasId = manifest.items.at(0).id;

        const assetId = json.target?.source?.id?.match(/assets\/(.+)\/canvas$/)[1];

        const url = new URL(window.location.href);

        // If selected canvas is the first one remove asset-id param.
        // If selected canvas is different than the value of asset-id, update asset-id.
        if (firstCanvasId.includes(assetId)) {
            url.searchParams.delete('asset-id');
            history.replaceState(null, '', url);
        } else if (url.searchParams.get('asset-id') !== assetId) {
            url.searchParams.set('asset-id', assetId);
            history.replaceState(null, '', url);
        }
    };

    return (
        <Viewer iiifContent={iiifContent}
                options={options}
                plugins={plugins}
                customTheme={customTheme}
                contentStateCallback={handleContentStateCallback}/>
    );
}
