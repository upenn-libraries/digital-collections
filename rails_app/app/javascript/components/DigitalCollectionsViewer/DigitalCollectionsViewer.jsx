import React, { useEffect, useState } from "react";

// IIIF Viewer Component
import IIIFViewer from "./IIIFViewer/IIIFViewer"

import ViewerErrorBoundary from "./ViewerErrorBoundary";
import fetchManifest from "./fetchManifest";

export default function DigitalCollectionsViewer({ manifestUrl, onStateChange, retryToken = 0 }) {
    const [manifest, setManifest] = useState(null);

    useEffect(() => {
        const controller = new AbortController();

        setManifest(null);
        onStateChange?.("loading");

        fetchManifest(manifestUrl, { signal: controller.signal })
            .then(setManifest)
            .catch((error) => {
                if (controller.signal.aborted) return;

                console.error("[clover-viewer] Unable to load IIIF manifest", error);
                onStateChange?.("error");
            });

        return () => controller.abort();
    }, [manifestUrl, retryToken, onStateChange]);

    if (!manifest) return null;

    return (
        <ViewerErrorBoundary
            onReady={() => onStateChange?.("ready")}
            onError={(error) => {
                console.error("[clover-viewer] Viewer failed to render", error);
                onStateChange?.("error");
            }}
        >
            <IIIFViewer manifest={manifest} />
        </ViewerErrorBoundary>
    );
}
