import React, { useState } from "react";
import * as Popover from "@radix-ui/react-popover";
import { makeBlob, mimicDownload } from "@samvera/image-downloader";

export default function DownloadButton({ useViewerState }) {
  const viewerState = useViewerState();
  const { activeCanvas, vault } = viewerState;
  const canvasData = vault.toPresentation3({
    id: activeCanvas,
    type: "Canvas",
  });
  const [open, setOpen] = useState(false);

  // download the image instead of opening it in browser
  const handleDownloadClick = async (e, url, size) => {
    e.preventDefault();

    const downloadFilename = `${canvasData.label.none[0]}-${size}`;
    const response = await makeBlob(url);

    if (!response || response.error) {
      alert("Error fetching the image");
      return;
    }

    mimicDownload(response, downloadFilename);
  };

  // Same URL generation logic as above
  const generateAssetUrls = () => {
    const iiifAssetPath = canvasData.items[0].items[0].body.id;
    const originalRendering = canvasData.rendering[0];
    return {
      small: iiifAssetPath.replace("!200,200", "1200,"),
      fullSize: iiifAssetPath.replace("!200,200", "max"),
      original: {
        label: originalRendering.label,
        path: originalRendering.id,
      },
    };
  };

  const assetUrls = generateAssetUrls();

  return (
    <Popover.Root open={open} onOpenChange={setOpen}>
      <Popover.Trigger asChild>
        <button
          type="button"
          className="dc-iiif-viewer-controls__button"
          aria-label="Download image"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="16"
            height="16"
            fill="currentColor"
            className="bi bi-download"
            viewBox="0 0 16 16"
            aria-hidden="true"
          >
            <path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5" />
            <path d="M7.646 11.854a.5.5 0 0 0 .708 0l3-3a.5.5 0 0 0-.708-.708L8.5 10.293V1.5a.5.5 0 0 0-1 0v8.793L5.354 8.146a.5.5 0 1 0-.708.708z" />
          </svg>
        </button>
      </Popover.Trigger>

      <Popover.Portal>
        <Popover.Content
          className="bg-white border rounded shadow-lg p-0 min-w-72"
          align="end"
          sideOffset={5}
        >
          <div className="p-3 border-bottom">
            <h6
              className="text-uppercase text-muted mb-0 fw-semibold"
              style={{ fontSize: "0.75rem", letterSpacing: "0.05em" }}
            >
              Download Selected Image
            </h6>
          </div>
          <ul className="list-unstyled list-group">
            <li>
              <button
                type="button"
                className="btn btn-link text-decoration-none"
                onClick={(event) =>
                  handleDownloadClick(event, assetUrls.small, "small")
                }
              >
                Small JPG
              </button>
            </li>
            <li>
              <button
                type="button"
                className="btn btn-link text-decoration-none"
                onClick={(event) =>
                  handleDownloadClick(event, assetUrls.fullSize, "full-size")
                }
              >
                Full-sized JPG
              </button>
            </li>
            <li>
              <a
                href={assetUrls.original.path}
                download
                className="btn btn-link text-decoration-none"
              >
                {assetUrls.original.label.en}
              </a>
            </li>
          </ul>
          <Popover.Arrow className="fill-purple" />
        </Popover.Content>
      </Popover.Portal>
    </Popover.Root>
  );
}
