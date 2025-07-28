import { createElement } from "react";
import { createRoot } from "react-dom/client";
import Viewer from "@samvera/clover-iiif/viewer";
import { Controller } from "@hotwired/stimulus";

const options = {
	showTitle: false,
	informationPanel: {
		open: false,
	},
};

export default class CloverViewerController extends Controller {
	static values = {
		url: String,
	};

	connect() {
		const root = createRoot(this.element);
		root.render(this.getViewer(this.urlValue));
	}

	getViewer(url) {
		return createElement(Viewer, {
			iiifContent: url,
			options: options,
		});
	}
}
