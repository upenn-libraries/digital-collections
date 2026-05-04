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
const buildDownloadLinks = (canvas) => {
  if (!canvas) return [];

  const iiifServicePath = canvas.items?.[0]?.items?.[0]?.body?.service?.[0]?.id;
  const original = canvas.rendering?.[0];

  const canvasName = canvas?.label?.none?.[0] ?? "download";

  const rows = [];

  if (iiifServicePath) {
    IIIF_DERIVATIVES.forEach(({ key, label, iiifPath }) => {
      rows.push({
        key,
        label,
        url: iiifServicePath + iiifPath,
        filename: `${canvasName}-${key}.jpg`
      });
    });
  }

  if (original) {
    rows.push({
      key: "original",
      label: original.label?.en?.[0] ?? "Original file",
      url: original.id,
      filename: `${canvasName}-original.tif`
    });
  }

  return rows;
};

// Order canvases in the order that they are displayed, not paginated, and extract all canvas data. For items
// that are right-to-left, we reverse the array so that the download links are on the appropriate side of the screen.
const getDownloadableCanvases = (visibleCanvases, viewingDirection, vault) => {
  let canvases = visibleCanvases.map((canvas) => vault.toPresentation3(canvas));

  return (viewingDirection === 'right-to-left') ? canvases.reverse() : canvases;
}

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
  const { vault, sequence, visibleCanvases, viewingDirection, isPaged } = useViewerState();

  const downloadableCanvases = getDownloadableCanvases(visibleCanvases, viewingDirection, vault);
  const multiplePages = sequence[0].length > 1;

  const handleDownloadClick = async (e, url, filename) => {
    e.preventDefault();

    const response = await makeBlob(url);

    if (!response || response.error) {
      alert("Error fetching the image");
      return;
    }

    mimicDownload(response, filename);
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
            {downloadableCanvases.map(canvas => {
              const links = buildDownloadLinks(canvas);
              const canvasLabel = canvas?.label?.none?.[0];

              return (
                <section className="dc-iiif-download__section" key={canvas.id}>

                  {multiplePages && <h3 className="dc-iiif-download__side">{canvasLabel}</h3>}

                  {links.length > 0 ? (
                    <ul className="dc-iiif-download__list">
                      {links.map((link) => (
                        <li
                          key={link.key}
                          className="dc-iiif-download__item"
                        >
                          <a
                            className="dc-iiif-download__link"
                            href={link.url}
                            target="_blank"
                            rel="noopener noreferrer"
                          >
                            {link.label}
                          </a>
                          <button
                            type="button"
                            className="pl-button dc-iiif-download__action"
                            aria-label={`Download ${link.label}`}
                            onClick={(e) =>
                              handleDownloadClick(
                                e,
                                link.url,
                                link.filename,
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
