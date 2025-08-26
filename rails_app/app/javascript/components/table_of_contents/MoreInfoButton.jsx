import React from "react";
import ClosePanel from "@components/viewer_icons/ClosePanel";
import OpenPanel from "@components/viewer_icons/OpenPanel";

export default function MoreInfoButton({ useViewerState, useViewerDispatch }) {
  const viewerState = useViewerState();
  const dispatch = useViewerDispatch();

  // toggle information panel
  function clickHandler() {
    dispatch({
      type: "updateInformationOpen",
      isInformationOpen: !viewerState.isInformationOpen,
    });
  }

  return (
    <button
      type="button"
      className="dc-iiif-viewer-controls__button"
      onClick={clickHandler}
      aria-label="More info"
      aria-expanded={viewerState.isInformationOpen}
    >
      {viewerState.isInformationOpen ? <ClosePanel /> : <OpenPanel />}
    </button>
  );
}
