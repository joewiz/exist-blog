/**
 * Admin post management — loads post list from API and provides CRUD actions.
 */

const API_BASE = "api";

async function loadPosts() {
  const resp = await fetch(`${API_BASE}/posts`, {
    credentials: "same-origin",
  });
  if (!resp.ok) {
    console.error("Failed to load posts:", resp.status);
    return;
  }
  const data = await resp.json();
  renderPostTable(data.posts || []);
}

function renderPostTable(posts) {
  const tbody = document.getElementById("admin-posts-body");
  if (!tbody) return;

  tbody.innerHTML = "";

  if (posts.length === 0) {
    tbody.innerHTML =
      '<tr><td colspan="5" style="text-align:center;color:#888;">No posts yet. Create your first post!</td></tr>';
    return;
  }

  for (const post of posts) {
    const tr = document.createElement("tr");
    const statusClass =
      post.status === "published" ? "status-published" : "status-draft";
    tr.innerHTML = `
      <td><a href="admin/editor/${post.slug}">${escapeHtml(post.title || "Untitled")}</a></td>
      <td>${escapeHtml(post.date || "")}</td>
      <td>${escapeHtml(post.author || "")}</td>
      <td><span class="${statusClass}">${post.status || "published"}</span></td>
      <td>
        <a href="admin/editor/${post.slug}" class="btn btn-small">Edit</a>
        <button class="btn btn-danger btn-small" data-slug="${escapeAttr(post.slug)}">Delete</button>
      </td>
    `;
    tbody.appendChild(tr);
  }

  // Attach delete handlers
  tbody.querySelectorAll("button[data-slug]").forEach((btn) => {
    btn.addEventListener("click", () => deletePost(btn.dataset.slug));
  });
}

async function deletePost(slug) {
  if (!confirm(`Delete post "${slug}"?`)) return;

  const resp = await fetch(`${API_BASE}/posts/${slug}`, {
    method: "DELETE",
    credentials: "same-origin",
  });
  if (resp.ok) {
    loadPosts();
  } else {
    alert("Failed to delete post");
  }
}

function escapeHtml(str) {
  const div = document.createElement("div");
  div.textContent = str;
  return div.innerHTML;
}

function escapeAttr(str) {
  return str.replace(/"/g, "&quot;").replace(/'/g, "&#39;");
}

// Initialize
document.addEventListener("DOMContentLoaded", loadPosts);
