const MAX_ATTEMPTS = 3;
const REQUEST_TIMEOUT_MS = 8000;
const RETRY_DELAYS_MS = [750, 2000];
const RETRYABLE_STATUSES = [408, 425, 429];

class ManifestError extends Error {
  constructor(message, { retryable = false, cause } = {}) {
    super(message, { cause });
    this.name = "ManifestError";
    this.retryable = retryable;
  }
}

const hasCanvases = (manifest) =>
  Array.isArray(manifest?.items) && typeof manifest.items[0]?.id === "string";

const isRetryableStatus = (status) =>
  status >= 500 || RETRYABLE_STATUSES.includes(status);

const wait = (ms, signal) =>
  new Promise((resolve, reject) => {
    const timer = setTimeout(resolve, ms);

    signal?.addEventListener("abort", () => {
      clearTimeout(timer);
      reject(signal.reason);
    }, { once: true });
  });

const requestManifest = async (url, signal) => {
  let response;

  try {
    response = await fetch(url, {
      signal: AbortSignal.any([signal, AbortSignal.timeout(REQUEST_TIMEOUT_MS)].filter(Boolean)),
      headers: { Accept: "application/json" }
    });
  } catch (cause) {
    if (signal?.aborted) throw cause;

    throw new ManifestError("Manifest request failed", { retryable: true, cause });
  }

  if (!response.ok) {
    throw new ManifestError(`Manifest request failed with status ${response.status}`, {
      retryable: isRetryableStatus(response.status)
    });
  }

  const manifest = await response.json().catch((cause) => {
    throw new ManifestError("Manifest response was not valid JSON", { cause });
  });

  if (!hasCanvases(manifest)) throw new ManifestError("Manifest has no canvases to display");

  return manifest;
};

export default async function fetchManifest(url, { signal } = {}) {
  for (let attempt = 1; ; attempt += 1) {
    try {
      return await requestManifest(url, signal);
    } catch (error) {
      if (signal?.aborted || !error.retryable || attempt === MAX_ATTEMPTS) throw error;
    }

    await wait(RETRY_DELAYS_MS[Math.min(attempt - 1, RETRY_DELAYS_MS.length - 1)], signal);
  }
}
