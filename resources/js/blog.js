/**
 * exist-blog: core JavaScript
 *
 * - Syntax highlighting for fenced code blocks
 * - TOC sidebar generation with active-section highlighting
 */

function applyHighlighting() {
    const hl = globalThis.highlightCode;
    if (!hl) return;
    document.querySelectorAll("pre code[class*='language-']").forEach((el) => {
        const lang = (el.className.match(/language-(\S+)/) || [])[1];
        if (lang) hl.highlightElement(el, lang);
    });
}

/**
 * Build a TOC sidebar for post-detail pages.
 *
 * Scans h2/h3 inside .post-body, assigns ids if missing,
 * populates .post-toc-list, shows the sidebar, and attaches
 * an IntersectionObserver that highlights the active heading link.
 */
function buildTOC() {
    const body = document.querySelector(".post-body");
    const sidebar = document.querySelector(".post-toc-sidebar");
    const list = document.querySelector(".post-toc-list");
    if (!body || !sidebar || !list) return;

    const headings = Array.from(body.querySelectorAll("h2, h3"));
    if (headings.length < 2) return; // not worth a TOC

    // Ensure every heading has an id
    const seen = {};
    headings.forEach((h) => {
        if (!h.id) {
            let base = h.textContent
                .trim()
                .toLowerCase()
                .replace(/[^\w\s-]/g, "")
                .replace(/\s+/g, "-");
            let id = base;
            let n = 1;
            while (seen[id]) { id = base + "-" + (++n); }
            h.id = id;
        }
        seen[h.id] = true;
    });

    // Build list items
    headings.forEach((h) => {
        const li = document.createElement("li");
        li.className = h.tagName === "H3" ? "toc-item toc-item-h3" : "toc-item toc-item-h2";
        const a = document.createElement("a");
        a.href = "#" + h.id;
        a.textContent = h.textContent.trim();
        a.dataset.tocTarget = h.id;
        li.appendChild(a);
        list.appendChild(li);
    });

    sidebar.removeAttribute("hidden");

    // IntersectionObserver: highlight the link for the topmost visible heading
    const links = list.querySelectorAll("a[data-toc-target]");
    const linkMap = {};
    links.forEach((a) => { linkMap[a.dataset.tocTarget] = a; });

    const visible = new Set();

    const observer = new IntersectionObserver(
        (entries) => {
            entries.forEach((entry) => {
                if (entry.isIntersecting) {
                    visible.add(entry.target.id);
                } else {
                    visible.delete(entry.target.id);
                }
            });

            // Activate the first heading in document order that is visible
            let activated = false;
            headings.forEach((h) => {
                const a = linkMap[h.id];
                if (!a) return;
                if (!activated && visible.has(h.id)) {
                    a.classList.add("toc-active");
                    activated = true;
                } else {
                    a.classList.remove("toc-active");
                }
            });

            // If nothing visible, keep the last scrolled-past heading active
            if (!activated) {
                const scrollY = window.scrollY;
                let last = null;
                headings.forEach((h) => {
                    if (h.getBoundingClientRect().top + window.scrollY <= scrollY + 80) {
                        last = h;
                    }
                });
                if (last && linkMap[last.id]) {
                    links.forEach((a) => a.classList.remove("toc-active"));
                    linkMap[last.id].classList.add("toc-active");
                }
            }
        },
        { rootMargin: "0px 0px -60% 0px", threshold: 0 }
    );

    headings.forEach((h) => observer.observe(h));
}

function setup() {
    applyHighlighting();
    buildTOC();
}

if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", setup);
} else {
    setup();
}
