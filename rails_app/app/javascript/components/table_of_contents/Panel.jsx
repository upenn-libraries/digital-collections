import React from "react";

export default function Panel({ useViewerDispatch, useViewerState }) {
  const viewerState = useViewerState();
  const dispatch = useViewerDispatch();

  const { activeManifest, vault } = viewerState;
  const manifestData = vault.toPresentation3({
    id: activeManifest,
    type: "Manifest",
  });

  const containerStyle = { padding: "0px 1.618rem 2rem" };
  const listStyleClasses = ["list-unstyled", "list-group"];
  const entryStyleClasses = ["list-group-item", "list-group-item-action"];

	// update the viewer state to display canvas attached to TOC entry
  const handleClick = (targetCanvas) => {
    dispatch({
      type: "updateActiveCanvas",
      canvasId: targetCanvas.id,
    });
  };

  return (
    <div style={containerStyle}>
      <ul className={listStyleClasses.join(" ")}>
        {manifestData.structures.map((range) => (
          <li key={range.id}>
            <button
              type="button"
              className={entryStyleClasses.join(" ")}
              onClick={() => handleClick(range.items[0])}
            >
              {range.label.none[0]}
            </button>
          </li>
        ))}
      </ul>
    </div>
  );
}
