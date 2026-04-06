/**
 * Markdown editor with live preview.
 *
 * - For new posts: blank form
 * - For existing posts: loads source from API and populates fields
 * - Live preview using a simple Markdown-to-HTML conversion (client-side)
 * - Save/publish sends to the Roaster API
 */

const API_BASE = "api";

// Detect if we're editing an existing post from the URL
// URL pattern: /admin/editor/{year}/{slug}
const pathParts = window.location.pathname.split("/admin/editor/");
const editSlug = pathParts.length > 1 ? pathParts[1].replace(/\/$/, "") : null;

const sourceEl = document.getElementById("markdown-source");
const previewEl = document.getElementById("markdown-preview");
const titleEl = document.getElementById("post-title");
const dateEl = document.getElementById("post-date");
const authorEl = document.getElementById("post-author");
const tagsEl = document.getElementById("post-tags");
const categoryEl = document.getElementById("post-category");
const summaryEl = document.getElementById("post-summary");
const slugEl = document.getElementById("post-slug");
const editorTitleEl = document.getElementById("editor-title");

// Set default date to today
if (dateEl && !dateEl.value) {
  dateEl.value = new Date().toISOString().slice(0, 10);
}

// Load existing post if editing
if (editSlug) {
  editorTitleEl.textContent = "Edit Post";
  loadPost(editSlug);
}

async function loadPost(slug) {
  const resp = await fetch(`${API_BASE}/posts/${slug}`, {
    credentials: "same-origin",
  });
  if (!resp.ok) {
    alert("Failed to load post: " + resp.status);
    return;
  }
  const post = await resp.json();

  titleEl.value = post.title || "";
  dateEl.value = post.date || "";
  authorEl.value = post.author || "";
  tagsEl.value = (post.tags || []).join(", ");
  categoryEl.value = post.category || "";
  summaryEl.value = post.summary || "";
  slugEl.value = slug.split("/").pop();
  sourceEl.value = post.body || "";

  updatePreview();
}

// Live preview with debounce
let previewTimeout;
if (sourceEl) {
  sourceEl.addEventListener("input", () => {
    clearTimeout(previewTimeout);
    previewTimeout = setTimeout(updatePreview, 300);
  });
}

function updatePreview() {
  if (!sourceEl || !previewEl) return;
  // Simple client-side Markdown rendering for preview
  previewEl.innerHTML = simpleMarkdownToHtml(sourceEl.value);
  // Re-highlight code blocks if highlight.js is loaded
  if (window.hljs) {
    previewEl.querySelectorAll("pre code").forEach((block) => {
      hljs.highlightElement(block);
    });
  }
}

/**
 * Minimal Markdown-to-HTML for live preview.
 * Not a full parser — just enough for a usable preview.
 */
function simpleMarkdownToHtml(md) {
  let html = md
    // Code blocks (fenced)
    .replace(/```(\w*)\n([\s\S]*?)```/g, (_, lang, code) => {
      const cls = lang ? ` class="language-${lang}"` : "";
      return `<pre><code${cls}>${escapeHtml(code.trim())}</code></pre>`;
    })
    // Headings
    .replace(/^#### (.+)$/gm, "<h4>$1</h4>")
    .replace(/^### (.+)$/gm, "<h3>$1</h3>")
    .replace(/^## (.+)$/gm, "<h2>$1</h2>")
    .replace(/^# (.+)$/gm, "<h1>$1</h1>")
    // Bold and italic
    .replace(/\*\*(.+?)\*\*/g, "<strong>$1</strong>")
    .replace(/\*(.+?)\*/g, "<em>$1</em>")
    // Inline code
    .replace(/`([^`]+)`/g, "<code>$1</code>")
    // Links
    .replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2">$1</a>')
    // Images
    .replace(/!\[([^\]]*)\]\(([^)]+)\)/g, '<img alt="$1" src="$2"/>')
    // Unordered lists
    .replace(/^- (.+)$/gm, "<li>$1</li>")
    // Blockquotes
    .replace(/^> (.+)$/gm, "<blockquote>$1</blockquote>")
    // Paragraphs (blank line separated)
    .replace(/\n\n/g, "</p><p>")
    // Line breaks
    .replace(/\n/g, "<br/>");

  // Wrap list items
  html = html.replace(/(<li>[\s\S]*?<\/li>)/g, "<ul>$1</ul>");
  // Deduplicate nested <ul> wrappers
  html = html.replace(/<\/ul>\s*<ul>/g, "");

  return `<p>${html}</p>`;
}

function escapeHtml(str) {
  const div = document.createElement("div");
  div.textContent = str;
  return div.innerHTML;
}

// Save handlers
document.getElementById("btn-save-draft")?.addEventListener("click", () => savePost("draft"));
document.getElementById("btn-publish")?.addEventListener("click", () => savePost("published"));

async function savePost(status) {
  const title = titleEl.value.trim();
  if (!title) {
    alert("Title is required");
    return;
  }

  const tags = tagsEl.value
    .split(",")
    .map((t) => t.trim())
    .filter(Boolean);

  if (editSlug) {
    // Update existing post — rebuild the full Markdown source with front matter
    const frontMatter = buildFrontMatter(title, dateEl.value, authorEl.value, tags,
      categoryEl.value, summaryEl.value, status);
    const source = frontMatter + "\n\n" + sourceEl.value;

    const resp = await fetch(`${API_BASE}/posts/${editSlug}`, {
      method: "PUT",
      credentials: "same-origin",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ source }),
    });

    if (resp.ok) {
      alert("Post updated!");
    } else {
      const err = await resp.json();
      alert("Error: " + (err.error || resp.status));
    }
  } else {
    // Create new post
    const resp = await fetch(`${API_BASE}/posts`, {
      method: "POST",
      credentials: "same-origin",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        title,
        date: dateEl.value,
        author: authorEl.value,
        tags,
        category: categoryEl.value,
        summary: summaryEl.value,
        status,
        slug: slugEl.value || undefined,
        content: sourceEl.value,
      }),
    });

    if (resp.ok) {
      const result = await resp.json();
      alert("Post created!");
      window.location.href = `admin/editor/${result.slug}`;
    } else {
      const err = await resp.json();
      alert("Error: " + (err.error || resp.status));
    }
  }
}

function buildFrontMatter(title, date, author, tags, category, summary, status) {
  const lines = ["---"];
  lines.push(`title: "${title}"`);
  if (date) lines.push(`date: ${date}`);
  if (author) lines.push(`author: ${author}`);
  lines.push(`tags: [${tags.join(", ")}]`);
  if (category) lines.push(`category: ${category}`);
  if (summary) lines.push(`summary: "${summary}"`);
  lines.push(`status: ${status}`);
  lines.push("---");
  return lines.join("\n");
}
