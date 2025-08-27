import React, { useState } from "react";
import { makeBlob, mimicDownload } from "@samvera/image-downloader";
import * as Popover from "@radix-ui/react-popover";
import Download from "@components/viewer_icons/Download";

const DEFAULT_SCALE = "!200,200";
const DOWNLOAD_OPTIONS = {
  small: {
    label: "Small JPG",
    iiifPath: "/full/1200,/0/default.jpg",
  },
  fullsize: {
    label: "Full-sized JPG",
    iiifPath: "/full/max/0/default.jpg",
  },
};

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

    const downloadFilename = `${canvasData.label.none[0]}-${size}.jpg`;
    const response = await makeBlob(url);

    if (!response || response.error) {
      alert("Error fetching the image");
      return;
    }

    mimicDownload(response, downloadFilename);
  };

  // Same URL generation logic as above
  const generateAssetUrls = () => {
    const iiifServicePath = canvasData.items[0].items[0].body.service[0].id;
    const originalRendering = canvasData.rendering[0];

    return {
      small: iiifServicePath + DOWNLOAD_OPTIONS.small.iiifPath,
      fullsize: iiifServicePath + DOWNLOAD_OPTIONS.fullsize.iiifPath,
      original: {
        label: originalRendering.label,
        path: originalRendering.id,
      },
    };
  };

  // this can be removed (maybe when we upgrade to React 19 with built in memoization)
  const assetUrls = generateAssetUrls();

  return (
    <Popover.Root open={open} onOpenChange={setOpen}>
      <Popover.Trigger asChild>
        <button
          type="button"
          className="dc-iiif-viewer-controls__button"
          aria-label="Download image"
        >
          <Download />
        </button>
      </Popover.Trigger>

      <Popover.Portal>
        <Popover.Content
          className="bg-white border rounded shadow-lg p-3 mt-2"
          align="end"
          sideOffset={5}
        >
          <h2 className="px-2 mb-3 me-2">Download image</h2>
          <ul className="list-unstyled list-group">
            {Object.entries(DOWNLOAD_OPTIONS).map(([key, option]) => (
              <li key={key}>
                <button
                  type="button"
                  className="btn btn-link text-decoration-none d-block w-100 text-start"
                  onClick={(event) =>
                    handleDownloadClick(event, assetUrls[key], key)
                  }
                >
                  {option.label}
                </button>
              </li>
            ))}
            <li>
              <a
                href={assetUrls.original.path}
                download
                className="btn btn-link text-decoration-none d-block w-100 text-start"
              >
                {assetUrls.original.label.en}
              </a>
            </li>
          </ul>
        </Popover.Content>
      </Popover.Portal>
    </Popover.Root>
  );
}
