import React, { useState, useEffect } from "react";

// Placeholder component to render while fetching manifest
import LoadingComponent from "./LoadingComponent";

// IIIF Viewer Component
import IIIFViewer from "./IIIFViewer/IIIFViewer"

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

    return manifest ? <IIIFViewer manifest={manifest} /> : <LoadingComponent />;
}
