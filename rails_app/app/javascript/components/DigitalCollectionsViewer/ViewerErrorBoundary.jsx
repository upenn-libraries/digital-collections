import { Component } from "react";

export default class ViewerErrorBoundary extends Component {
    state = { hasError: false };

    static getDerivedStateFromError() {
        return { hasError: true };
    }

    componentDidMount() {
        if (!this.state.hasError) this.props.onReady?.();
    }

    componentDidCatch(error) {
        this.props.onError?.(error);
    }

    render() {
        return this.state.hasError ? null : this.props.children;
    }
}
