import React from "react";
import { makeBlob, mimicDownload } from "@samvera/image-downloader";
import * as Popover from "@radix-ui/react-popover";

const IIIF_DERIVATIVES = [
  { key: "small", label: "Small JPG", iiifPath: "/full/1200,/0/default.jpg" },
  { key: "fullsize", label: "Full-sized JPG", iiifPath: "/full/max/0/default.jpg" },
];

// Build the list of download/link rows for a single canvas. Skips
// derivatives or original entries that aren't present so each section
// renders only what's actually available.
const buildAssetRows = (canvas) => {
  if (!canvas) return [];

  const iiifServicePath = canvas.items?.[0]?.items?.[0]?.body?.service?.[0]?.id;
  const original = canvas.rendering?.[0];

  const rows = [];

  if (iiifServicePath) {
    IIIF_DERIVATIVES.forEach(({ key, label, iiifPath }) => {
      rows.push({
        key,
        label,
        url: iiifServicePath + iiifPath,
        filenameSuffix: key,
      });
    });
  }

  if (original) {
    rows.push({
      key: "original",
      label: original.label?.en?.[0] ?? "Original file",
      url: original.id,
      filenameSuffix: "original",
    });
  }

  return rows;
};

// Resolve which canvases are showing as the left/right pages of a
// paged-spread item. Canvas 0 is rendered alone (typical cover);
// subsequent canvases pair as (1=left, 2=right), (3=left, 4=right), etc.
// for left-to-right reading. Right-to-left reading flips the parity.
const resolveSpread = (canvases, activeCanvasId, viewingDirection) => {
  const idx = canvases.findIndex((c) => c.id === activeCanvasId);
  if (idx < 0) return { left: null, right: null };

  if (idx === 0) {
    return viewingDirection === "right-to-left"
      ? { left: canvases[idx], right: null }
      : { left: null, right: canvases[idx] };
  }

  const isLeftSide =
    viewingDirection === "right-to-left" ? idx % 2 === 0 : idx % 2 === 1;

  if (isLeftSide) {
    return { left: canvases[idx], right: canvases[idx + 1] ?? null };
  }
  return { left: canvases[idx - 1] ?? null, right: canvases[idx] };
};

const DownloadIcon = ({ size = 24 }) => (
  <svg
    xmlns="http://www.w3.org/2000/svg"
    height={`${size}px`}
    width={`${size}px`}
    viewBox="0 -960 960 960"
    fill="currentColor"
    aria-hidden="true"
  >
    <path d="M480-320 280-520l56-58 104 104v-326h80v326l104-104 56 58-200 200ZM240-160q-33 0-56.5-23.5T160-240v-120h80v120h480v-120h80v120q0 33-23.5 56.5T720-160H240Z" />
  </svg>
);

export default function DownloadButton({ useViewerState }) {
  const viewerState = useViewerState();
  const { activeCanvas, activeManifest, vault } = viewerState;

  const manifest = vault.toPresentation3({
    id: activeManifest,
    type: "Manifest",
  });
  const isPaged = manifest?.behavior?.includes("paged") ?? false;
  const viewingDirection = manifest?.viewingDirection ?? "left-to-right";

  let sections = [];

  if (isPaged) {
    const spread = resolveSpread(
      manifest.items,
      activeCanvas,
      viewingDirection,
    );
    if (spread.left) sections.push({ side: "left", canvasRef: spread.left });
    if (spread.right) sections.push({ side: "right", canvasRef: spread.right });
  }

  if (sections.length === 0) {
    sections = [{ side: null, canvasRef: { id: activeCanvas } }];
  }

  // Resolve full canvas data (with rendering and image service) for each section.
  sections = sections.map(({ side, canvasRef }) => ({
    side,
    canvas: canvasRef?.id
      ? vault.toPresentation3({ id: canvasRef.id, type: "Canvas" })
      : null,
  }));

  const handleDownloadClick = async (e, url, filenameSuffix, canvas) => {
    e.preventDefault();

    const baseName = canvas?.label?.none?.[0] ?? "download";
    const downloadFilename = `${baseName}-${filenameSuffix}.jpg`;
    const response = await makeBlob(url);

    if (!response || response.error) {
      alert("Error fetching the image");
      return;
    }

    mimicDownload(response, downloadFilename);
  };

  return (
    <Popover.Root>
      <Popover.Trigger asChild>
        <button
          type="button"
          className="dc-iiif-viewer-controls__button dc-iiif-download__trigger"
          aria-label="Download image"
        >
          <DownloadIcon size={24} />
        </button>
      </Popover.Trigger>

      <Popover.Portal>
        <Popover.Content
          className="dc-iiif-download"
          align="end"
          sideOffset={5}
          collisionPadding={8}
          hideWhenDetached
        >
          <h2 className="dc-iiif-download__heading">Download</h2>
          <div
            className="dc-iiif-download__sections"
            data-paged={isPaged ? "" : undefined}
          >
            {sections.map(({ side, canvas }) => {
              const rows = buildAssetRows(canvas);
              const sideLabel = side === "left" ? "Left page" : "Right page";
              const canvasLabel = canvas?.label?.none?.[0];
              const pageLabel = canvasLabel
                ? `${sideLabel} (${canvasLabel})`
                : sideLabel;
              return (
                <section
                  key={side ?? "single"}
                  className="dc-iiif-download__section"
                >
                  {side && (
                    <h3 className="dc-iiif-download__side">{pageLabel}</h3>
                  )}
                  {rows.length > 0 ? (
                    <ul className="dc-iiif-download__list">
                      {rows.map((row) => (
                        <li
                          key={row.key}
                          className="dc-iiif-download__item"
                        >
                          <a
                            className="dc-iiif-download__link"
                            href={row.url}
                            target="_blank"
                            rel="noopener noreferrer"
                          >
                            {row.label}
                          </a>
                          <button
                            type="button"
                            className="pl-button dc-iiif-download__action"
                            aria-label={
                              side
                                ? `Download ${pageLabel} — ${row.label}`
                                : `Download ${row.label}`
                            }
                            onClick={(e) =>
                              handleDownloadClick(
                                e,
                                row.url,
                                row.filenameSuffix,
                                canvas,
                              )
                            }
                          >
                            <DownloadIcon size={24} />
                          </button>
                        </li>
                      ))}
                    </ul>
                  ) : (
                    <p className="dc-iiif-download__empty">
                      No download options available.
                    </p>
                  )}
                </section>
              );
            })}
          </div>
        </Popover.Content>
      </Popover.Portal>
    </Popover.Root>
  );
}
