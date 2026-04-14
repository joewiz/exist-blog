#!/usr/bin/env python3
"""
Re-import AtomicWiki posts from HTML dump to proper Markdown.

Source: ~/Downloads/atomic-wiki-data-dump/data/blogs/eXist/
Output: ~/workspace/exist-blog/data/posts/YEAR/slug.md (flat, no archive/)

For each .atom file:
  - Extract metadata (title, date, author, wiki:id)
  - Find corresponding .html file
  - Convert HTML to Markdown via pandoc (with namespace stripping + code block handling)
  - Write with YAML front matter

Also updates data/redirects.tsv to remove the archive/ prefix from new-url paths.
"""

import os
import re
import sys
import subprocess
import xml.etree.ElementTree as ET
from pathlib import Path
from html import unescape
from urllib.parse import unquote

DUMP_DIR = Path.home() / "Downloads/atomic-wiki-data-dump/data/blogs/eXist"
OUTPUT_DIR = Path.home() / "workspace/exist-blog/data/posts"
REDIRECTS_FILE = Path.home() / "workspace/exist-blog/data/redirects.tsv"

# XML namespace map
ATOM_NS = "http://www.w3.org/2005/Atom"
WIKI_NS = "http://exist-db.org/xquery/wiki"
XHTML_NS = "http://www.w3.org/1999/xhtml"

# Code block class pattern: ext:code?lang=xquery
CODE_CLASS_RE = re.compile(r'ext:code\?lang=(\w+)')

# Language aliases for pandoc fenced blocks
LANG_MAP = {
    "xml": "xml",
    "xquery": "xquery",
    "xql": "xquery",
    "java": "java",
    "javascript": "javascript",
    "js": "javascript",
    "html": "html",
    "css": "css",
    "bash": "bash",
    "shell": "bash",
    "text": "text",
    "json": "json",
}


def strip_ns(tag):
    """Strip namespace from an ElementTree tag."""
    if tag.startswith("{"):
        return tag.split("}", 1)[1]
    return tag


def elem_to_html(elem):
    """
    Convert an ElementTree element (with XHTML namespaces) to plain HTML string.
    Handles the special ext:code div for code blocks.
    """
    tag = strip_ns(elem.tag)
    cls = elem.get("class", "")

    # Code blocks: <div class="ext:code?lang=...">...</div>
    m = CODE_CLASS_RE.search(cls)
    if tag == "div" and m:
        lang = LANG_MAP.get(m.group(1), m.group(1))
        # Content is text nodes with escaped HTML — decode them
        raw = "".join(elem.itertext())
        # The content often has leading/trailing whitespace and a newline
        code = raw.strip("\n")
        return f"<pre><code class=\"language-{lang}\">{_escape_html(code)}</code></pre>\n"

    # Build opening tag
    attrs = ""
    for k, v in elem.items():
        if k == "class":
            continue  # skip original class
        local_k = strip_ns(k)
        attrs += f' {local_k}="{v}"'

    # Void elements
    void_tags = {"br", "hr", "img", "input", "link", "meta"}
    if tag in void_tags:
        return f"<{tag}{attrs}/>"

    # Recurse children
    inner = (elem.text or "")
    for child in elem:
        inner += elem_to_html(child)
        inner += (child.tail or "")

    return f"<{tag}{attrs}>{inner}</{tag}>"


def _escape_html(text):
    """Re-escape HTML special chars for embedding in <code>."""
    return (text
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;"))


def html_file_to_markdown(html_path: Path) -> str:
    """Parse the XHTML content file and convert to Markdown via pandoc."""
    # Some newer posts are already Markdown
    if html_path.suffix == ".md":
        return html_path.read_text(encoding="utf-8")

    try:
        tree = ET.parse(html_path)
    except ET.ParseError as e:
        print(f"  WARNING: XML parse error in {html_path.name}: {e}", file=sys.stderr)
        # Fall back: pass raw text to pandoc as HTML
        raw = html_path.read_text(encoding="utf-8")
        result = subprocess.run(
            ["pandoc", "-f", "html", "-t", "gfm", "--wrap=none"],
            input=raw,
            capture_output=True,
            text=True,
            encoding="utf-8",
        )
        return result.stdout if result.returncode == 0 else raw

    root = tree.getroot()
    # The root element is always a wrapper <div> — render its children directly
    # to avoid an unnecessary <div> in the Markdown output.
    inner_text = root.text or ""
    inner_children = "".join(
        elem_to_html(child) + (child.tail or "")
        for child in root
    )
    html_body = inner_text + inner_children
    html_doc = f"<html><body>{html_body}</body></html>"

    result = subprocess.run(
        ["pandoc", "-f", "html", "-t", "gfm", "--wrap=none"],
        input=html_doc,
        capture_output=True,
        text=True,
        encoding="utf-8",
    )
    if result.returncode != 0:
        print(f"  WARNING: pandoc error for {html_path.name}: {result.stderr}", file=sys.stderr)
        return html_body

    return result.stdout


def parse_atom(atom_path: Path):
    """Parse an .atom entry file. Returns dict with title, date, author, wiki_id, content_src, tags."""
    try:
        tree = ET.parse(atom_path)
    except ET.ParseError as e:
        print(f"  ERROR parsing {atom_path}: {e}", file=sys.stderr)
        return None

    root = tree.getroot()
    ns = {"a": ATOM_NS, "wiki": WIKI_NS}

    title_el = root.find("a:title", ns)
    title = title_el.text.strip() if title_el is not None and title_el.text else atom_path.stem

    published_el = root.find("a:published", ns)
    if published_el is None:
        published_el = root.find("a:updated", ns)
    date_str = ""
    if published_el is not None and published_el.text:
        # e.g. 2011-06-25T21:24:08+02:00 → 2011-06-25
        date_str = published_el.text[:10]

    author_el = root.find("a:author/a:name", ns)
    author = author_el.text.strip() if author_el is not None and author_el.text else ""

    wiki_id_el = root.find("wiki:id", ns)
    wiki_id = wiki_id_el.text.strip() if wiki_id_el is not None and wiki_id_el.text else atom_path.stem

    # Collect tags from <category term="..."/>
    tags = []
    for cat_el in root.findall("a:category", ns):
        term = cat_el.get("term", "").strip()
        if term:
            tags.append(term)

    content_el = root.find("a:content", ns)
    html_src = ""
    if content_el is not None:
        html_src = content_el.get("src", "")

    return {
        "title": title,
        "date": date_str,
        "author": author,
        "wiki_id": wiki_id,
        "html_src": html_src,
        "tags": tags,
    }


def slug_from_wiki_id(wiki_id: str) -> str:
    """Convert a wiki ID like 'AkismetAPI' to a URL-friendly slug."""
    # URL-decode first (some IDs are percent-encoded)
    wiki_id = unquote(wiki_id)
    # Insert hyphen before uppercase letters that follow lowercase or digits
    slug = re.sub(r"([a-z0-9])([A-Z])", r"\1-\2", wiki_id)
    # Replace spaces and underscores with hyphens
    slug = re.sub(r"[\s_]+", "-", slug)
    # Lowercase
    slug = slug.lower()
    # Remove any remaining non-alphanumeric chars except hyphens
    slug = re.sub(r"[^a-z0-9-]", "", slug)
    # Collapse multiple hyphens
    slug = re.sub(r"-+", "-", slug)
    return slug.strip("-")


def escape_yaml_string(s: str) -> str:
    """Escape a string for YAML front matter."""
    # Use double quotes if it contains special chars
    if any(c in s for c in ['"', "'", ":", "#", "{", "}", "[", "]", ","]):
        return '"' + s.replace("\\", "\\\\").replace('"', '\\"') + '"'
    return f'"{s}"'


def write_post(meta: dict, content: str, out_path: Path):
    """Write the Markdown file with YAML front matter."""
    out_path.parent.mkdir(parents=True, exist_ok=True)

    title_yaml = escape_yaml_string(meta["title"])
    author_yaml = escape_yaml_string(meta["author"]) if meta["author"] else '""'
    wiki_id_yaml = escape_yaml_string(meta["wiki_id"])
    original_url = f"https://exist-db.org/exist/apps/wiki/blogs/eXist/{meta['wiki_id']}"

    # Format tags as YAML list
    tags = meta.get("tags", [])
    if tags:
        tags_yaml = "\n" + "".join(f'  - "{t}"\n' for t in tags)
    else:
        tags_yaml = " []\n"

    front_matter = f"""---
title: {title_yaml}
date: {meta['date']}
author: {author_yaml}
tags:{tags_yaml}status: published
migrated-from: AtomicWiki
original-id: {wiki_id_yaml}
original-url: "{original_url}"
---

"""

    out_path.write_text(front_matter + content, encoding="utf-8")


def update_redirects(redirects_path: Path):
    """Remove archive/ prefix from new-url paths in redirects.tsv."""
    if not redirects_path.exists():
        print(f"  WARNING: redirects file not found: {redirects_path}", file=sys.stderr)
        return

    lines = redirects_path.read_text(encoding="utf-8").splitlines()
    updated = []
    changed = 0
    for line in lines:
        # TSV: old-url\tnew-url
        parts = line.split("\t")
        if len(parts) >= 2:
            new_url = parts[1]
            # Remove /archive/ segment
            new_new_url = re.sub(r'/archive/', '/', new_url)
            if new_new_url != new_url:
                changed += 1
                parts[1] = new_new_url
            updated.append("\t".join(parts))
        else:
            updated.append(line)

    redirects_path.write_text("\n".join(updated) + "\n", encoding="utf-8")
    print(f"  Updated {changed} redirect paths (removed archive/ prefix)")


def main():
    atom_files = sorted(DUMP_DIR.glob("*.atom"))
    # Exclude the feed/main atom files
    atom_files = [f for f in atom_files if f.stem not in ("BlogsMain", "feed")]

    print(f"Found {len(atom_files)} .atom files in {DUMP_DIR}")
    print()

    success = 0
    skipped = 0
    errors = 0

    for atom_path in atom_files:
        meta = parse_atom(atom_path)
        if meta is None:
            errors += 1
            continue

        if not meta["date"]:
            print(f"  SKIP (no date): {atom_path.name}")
            skipped += 1
            continue

        year = meta["date"][:4]
        slug = slug_from_wiki_id(meta["wiki_id"])

        # Find content file (HTML or Markdown)
        html_src = meta["html_src"]
        if html_src:
            content_path = DUMP_DIR / html_src
        else:
            # Try .html first, fall back to .md
            content_path = DUMP_DIR / (atom_path.stem + ".html")
            if not content_path.exists():
                content_path = DUMP_DIR / (atom_path.stem + ".md")

        if not content_path.exists():
            print(f"  SKIP (no content): {atom_path.name}")
            skipped += 1
            continue

        out_path = OUTPUT_DIR / year / f"{slug}.md"
        print(f"  {atom_path.stem} → {year}/{slug}.md", end=" ... ", flush=True)

        content = html_file_to_markdown(content_path)
        write_post(meta, content, out_path)
        print("ok")
        success += 1

    print()
    print(f"Done: {success} written, {skipped} skipped, {errors} errors")
    print()

    # Update redirects.tsv
    print(f"Updating {REDIRECTS_FILE} ...")
    update_redirects(REDIRECTS_FILE)
    print("Done.")

    # Report old archive/ dirs to remove
    archive_dir = OUTPUT_DIR / "archive"
    if archive_dir.exists():
        print()
        print(f"The old archive/ directory still exists: {archive_dir}")
        print("Review the new posts, then run:")
        print(f"  git rm -r {archive_dir}")


if __name__ == "__main__":
    main()
