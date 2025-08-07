import React, { useState } from "react";

const buttonStyles = {
  width: "2rem",
  height: "2rem",
  margin: "0 0 0 0.618rem",
  cursor: "pointer",
  border: 0,
  borderRadius: "50%",
  color: "var(--colors-secondary, #000)",
  backgroundColor: "var(--colors-primary, #fff)",
  transition: "background-color 0.1s ease",
};

const buttonHoverStyles = {
  ...buttonStyles,
  backgroundColor: "var(--colors-accent, #007bff)",
};

export default function Button({ useViewerState, useViewerDispatch }) {
  const [isHovered, setIsHovered] = useState(false);
  const viewerState = useViewerState();
  const dispatch = useViewerDispatch();

  // toggle information panel
  function clickHandler() {
    dispatch({
      type: "updateInformationOpen",
      isInformationOpen: !viewerState.isInformationOpen,
    });
  }

  function buttonIcon() {
    if (!viewerState.isInformationOpen) {
      return (
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="16"
          height="16"
          fill="currentColor"
          className="bi bi-list"
          viewBox="0 0 16 16"
        >
          <title>More information</title>
          <path
            fillRule="evenodd"
            d="M2.5 12a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5m0-4a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5m0-4a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5"
          />
        </svg>
      );
    }
    return (
      <svg
        xmlns="http://www.w3.org/2000/svg"
        width="16"
        height="16"
        fill="currentColor"
        className="bi bi-x-lg"
        viewBox="0 0 16 16"
      >
        <title>Close information panel</title>
        <path d="M2.146 2.854a.5.5 0 1 1 .708-.708L8 7.293l5.146-5.147a.5.5 0 0 1 .708.708L8.707 8l5.147 5.146a.5.5 0 0 1-.708.708L8 8.707l-5.146 5.147a.5.5 0 0 1-.708-.708L7.293 8z" />
      </svg>
    );
  }

  return (
    <button
      type="button"
      className="d-flex align-items-center justify-content-center"
      style={isHovered ? buttonHoverStyles : buttonStyles}
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => setIsHovered(false)}
      onClick={clickHandler}
    >
      {buttonIcon()}
    </button>
  );
}
