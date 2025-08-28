import React from "react";

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
      {viewerState.isInformationOpen ? (
        <svg
          xmlns="http://www.w3.org/2000/svg"
          height="24px"
          viewBox="0 -960 960 960"
          width="24px"
          fill="currentColor"
          aria-hidden="true"
        >
          <path d="M300-640v320l160-160-160-160ZM200-120q-33 0-56.5-23.5T120-200v-560q0-33 23.5-56.5T200-840h560q33 0 56.5 23.5T840-760v560q0 33-23.5 56.5T760-120H200Zm440-80h120v-560H640v560Zm-80 0v-560H200v560h360Zm80 0h120-120Z" />
        </svg>
      ) : (
        <svg
          xmlns="http://www.w3.org/2000/svg"
          height="24px"
          viewBox="0 -960 960 960"
          width="24px"
          fill="currentColor"
          aria-hidden="true"
        >
          <path d="M460-320v-320L300-480l160 160ZM200-120q-33 0-56.5-23.5T120-200v-560q0-33 23.5-56.5T200-840h560q33 0 56.5 23.5T840-760v560q0 33-23.5 56.5T760-120H200Zm440-80h120v-560H640v560Zm-80 0v-560H200v560h360Zm80 0h120-120Z" />
        </svg>
      )}
    </button>
  );
}
