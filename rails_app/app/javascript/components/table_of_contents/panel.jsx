import React from "react";

export default function Panel(props) {
	const { canvas, useViewerDispatch, useViewerState } = props;
	const viewerState = useViewerState();
	const { activeManifest, vault } = viewerState;
	const data = vault.toPresentation3({ id: activeManifest, type: "Manifest" });

	// use useViewerDispatch to update viewer state
	const dispatch = useViewerDispatch();

	// console.log(data);
	// data.structures.map((range, index) => console.log(range.items[0].id));

	function clickHandler(targetCanvas) {
		dispatch({
			type: "updateActiveCanvas",
			canvasId: targetCanvas.id,
		});
	}

	return (
		<div style={{ padding: "0px 1.618rem 2rem" }}>
			<ul className="list-unstyled list-group list-group-flush">
				{data.structures.map((range, index) => (
					<li key={index}>
						<button
							type="button"
							className="list-group-item list-group-item-action"
							onClick={() => clickHandler(range.items[0])}
						>
							{range.label.none[0]}
						</button>
					</li>
				))}
			</ul>
		</div>
	);
}
