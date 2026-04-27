import React, { useState } from "react";

export default function EntriesPanel({ useViewerDispatch, useViewerState }) {
  const [activeEntry, setActiveEntry] = useState(null);

  const viewerState = useViewerState();
  const dispatch = useViewerDispatch();

  const { activeManifest, vault } = viewerState;
  const manifestData = vault.toPresentation3({
    id: activeManifest,
    type: "Manifest",
  });

  // update the viewer state to display canvas attached to TOC entry
  const handleClick = (targetCanvas) => {
    setActiveEntry(targetCanvas.id);
    dispatch({
      type: "updateActiveCanvas",
      canvasId: targetCanvas.id,
    });
  };

  return (
    <ol className="dc-iiif-table-of-contents" style={{ margin: "0 1.618rem" }}>
      {manifestData.structures.map((range) => (
        <li key={range.id}>
          <button
            type="button"
            onClick={() => handleClick(range.items[0])}
            aria-current={activeEntry === range.items[0].id}
          >
            {range.label.none[0]}
          </button>
        </li>
      ))}
    </ol>
  );
}
