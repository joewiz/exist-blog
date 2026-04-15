/**
 * exist-blog: core JavaScript
 *
 * Syntax highlighting for fenced code blocks rendered by exist-markdown.
 * The markdown renderer outputs pre>code.language-* for fenced code blocks.
 * We apply CM6/Lezer highlighting (same engine as eXide + Notebook).
 */

function applyHighlighting() {
    const hl = globalThis.highlightCode;
    if (!hl) return;
    document.querySelectorAll("pre code[class*='language-']").forEach((el) => {
        const lang = (el.className.match(/language-(\S+)/) || [])[1];
        if (lang) hl.highlightElement(el, lang);
    });
}

if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", applyHighlighting);
} else {
    applyHighlighting();
}
