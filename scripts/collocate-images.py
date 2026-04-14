#!/usr/bin/env python3
"""
Co-locate images with blog posts:
1. Scan converted Markdown files for local image references
2. Copy images from resources/images/archive/ to data/posts/YEAR/
3. Update Markdown front matter with original-image-urls metadata
4. Update image references in Markdown to relative paths
5. Update redirects.tsv to point to new image locations

Images referenced by multiple years are copied to each year directory.
"""

import os
import re
import shutil
import sys
from pathlib import Path
from urllib.parse import unquote

BLOG_DIR = Path.home() / "workspace/exist-blog"
POSTS_DIR = BLOG_DIR / "data/posts"
IMAGES_ARCHIVE = BLOG_DIR / "resources/images/archive"
REDIRECTS_FILE = BLOG_DIR / "data/redirects.tsv"

# Old AtomicWiki base URL for image redirects
OLD_IMAGE_BASE = "https://exist-db.org/exist/apps/wiki/data/blogs/eXist"

# Regex to find image references in Markdown and HTML
# Matches: ![alt](filename.png), <img src="filename.png"/>, /blogs/eXist/filename.png
IMG_MD_RE = re.compile(r'!\[[^\]]*\]\(([^)]+\.(?:png|jpg|gif|svg|jpeg))[^)]*\)', re.IGNORECASE)
IMG_HTML_RE = re.compile(r'<img[^>]+src=["\']([^"\']+\.(?:png|jpg|gif|svg|jpeg))[^"\']*["\']', re.IGNORECASE)
# Absolute refs to /blogs/eXist/
BLOG_ABS_RE = re.compile(r'/blogs/eXist/([^")\s]+\.(?:png|jpg|gif|svg|jpeg))', re.IGNORECASE)


def is_local_ref(src: str) -> bool:
    """Return True if this is a local file reference (not http/https/data)."""
    return not src.startswith(("http://", "https://", "data:", "//", "/exist/"))


def extract_filename(src: str) -> str:
    """Get just the filename from a path reference."""
    return Path(unquote(src)).name


def find_image_refs(md_text: str) -> list[tuple[str, str]]:
    """
    Find all local image references in Markdown text.
    Returns list of (original_src, filename) tuples.
    """
    refs = []
    seen = set()

    for m in IMG_MD_RE.finditer(md_text):
        src = m.group(1)
        if is_local_ref(src):
            fname = extract_filename(src)
            if fname not in seen:
                refs.append((src, fname))
                seen.add(fname)

    for m in IMG_HTML_RE.finditer(md_text):
        src = m.group(1)
        if is_local_ref(src):
            fname = extract_filename(src)
            if fname not in seen:
                refs.append((src, fname))
                seen.add(fname)

    for m in BLOG_ABS_RE.finditer(md_text):
        src = m.group(0)  # full /blogs/eXist/foo.png
        fname = extract_filename(m.group(1))
        if fname not in seen:
            refs.append((src, fname))
            seen.add(fname)

    return refs


def rewrite_image_refs(md_text: str, rewrites: dict) -> str:
    """
    Replace image references in Markdown text with rewritten paths.
    rewrites: {original_src: new_src}
    """
    result = md_text

    for old_src, new_src in rewrites.items():
        # Markdown: ![alt](old_src) → ![alt](new_src)
        result = result.replace(f']({old_src})', f']({new_src})')
        result = result.replace(f']({old_src} ', f']({new_src} ')
        # HTML img src="..."
        result = result.replace(f'src="{old_src}"', f'src="{new_src}"')
        result = result.replace(f"src='{old_src}'", f"src='{new_src}'")
        # Absolute refs like /blogs/eXist/foo.png
        # (also handled by general string replace if old_src starts with /blogs/)

    return result


def update_front_matter(md_text: str, image_urls: list[str]) -> str:
    """
    Add original-image-urls list to YAML front matter.
    Replaces or inserts before the closing --- of front matter.
    """
    if not image_urls or not md_text.startswith("---"):
        return md_text

    # Find closing ---
    rest = md_text[3:]
    close_idx = rest.find("\n---")
    if close_idx < 0:
        return md_text

    front = rest[:close_idx]
    after = rest[close_idx:]  # starts with \n---

    # Remove existing original-image-urls if present
    front = re.sub(r'\noriginal-image-urls:.*?(?=\n\w|\Z)', '', front, flags=re.DOTALL)

    urls_yaml = "\noriginal-image-urls:\n" + "".join(f'  - "{u}"\n' for u in image_urls)
    # Insert before closing ---
    return "---" + front + urls_yaml + after


def update_redirects(redirects_path: Path, image_rewrites: dict):
    """
    Update image redirect entries: old new-url → new new-url.
    image_rewrites: {filename: (year, new_app_path)}
    e.g. {"sarit.png": ("2014", "/exist/apps/blog/data/posts/2014/sarit.png")}
    """
    if not redirects_path.exists():
        return

    lines = redirects_path.read_text(encoding="utf-8").splitlines()
    updated = []
    changed = 0

    for line in lines:
        parts = line.split("\t")
        if len(parts) >= 2:
            old_url, new_url = parts[0], parts[1]
            # Try to find a matching image filename
            matched = False
            for fname, (year, new_path) in image_rewrites.items():
                encoded_name = fname.replace(" ", "%20")
                if encoded_name in old_url or fname in old_url:
                    if new_url != new_path:
                        parts[1] = new_path
                        changed += 1
                    matched = True
                    break
            updated.append("\t".join(parts))
        else:
            updated.append(line)

    redirects_path.write_text("\n".join(updated) + "\n", encoding="utf-8")
    print(f"  Updated {changed} image redirect paths")


def main():
    # Scan all converted posts (non-archive)
    md_files = [f for f in POSTS_DIR.rglob("*.md")
                if "archive" not in f.parts]

    print(f"Scanning {len(md_files)} Markdown files for local image references...")

    # Build: filename → list of post files that reference it
    image_to_posts: dict[str, list[Path]] = {}
    # Also: filename → list of original src strings used (for rewriting)
    image_to_srcs: dict[str, list[str]] = {}

    for md_path in sorted(md_files):
        text = md_path.read_text(encoding="utf-8")
        refs = find_image_refs(text)
        for (src, fname) in refs:
            image_to_posts.setdefault(fname, []).append(md_path)
            image_to_srcs.setdefault(fname, []).append(src)

    print(f"Found {len(image_to_posts)} unique local images referenced\n")

    # Track rewrites for redirects.tsv: fname → (year, new_app_path)
    # For images used in multiple years, we'll note all
    image_redirect_targets: dict[str, tuple[str, str]] = {}

    # Process each post file
    posts_updated = 0

    for md_path in sorted(md_files):
        text = md_path.read_text(encoding="utf-8")
        refs = find_image_refs(text)
        if not refs:
            continue

        year = md_path.parent.name  # e.g. "2014"
        rewrites = {}
        image_urls_for_fm = []

        for (src, fname) in refs:
            # Find source image
            src_image = IMAGES_ARCHIVE / fname
            if not src_image.exists():
                # Try URL-decoded name
                decoded_fname = unquote(fname)
                src_image_decoded = IMAGES_ARCHIVE / decoded_fname
                if src_image_decoded.exists():
                    fname = decoded_fname
                    src_image = src_image_decoded
                else:
                    print(f"  WARNING: image not found: {fname} (referenced in {md_path.name})")
                    continue

            # Copy to year directory
            dest_image = md_path.parent / fname
            if not dest_image.exists():
                shutil.copy2(src_image, dest_image)
                print(f"  Copied {fname} → {year}/{fname}")

            # Rewrite src to relative filename
            rewrites[src] = fname

            # Record original URL for front matter metadata
            original_url = f"{OLD_IMAGE_BASE}/{fname}"
            image_urls_for_fm.append(original_url)

            # Record for redirects: use first (earliest) year seen
            if fname not in image_redirect_targets:
                new_app_path = f"/exist/apps/blog/data/posts/{year}/{fname}"
                image_redirect_targets[fname] = (year, new_app_path)

        if rewrites:
            # Update image references in text
            new_text = rewrite_image_refs(text, rewrites)
            # Add image URLs to front matter
            new_text = update_front_matter(new_text, image_urls_for_fm)

            if new_text != text:
                md_path.write_text(new_text, encoding="utf-8")
                posts_updated += 1

    print(f"\nUpdated {posts_updated} post files")

    # Update redirects.tsv
    print(f"\nUpdating redirects.tsv...")
    update_redirects(REDIRECTS_FILE, image_redirect_targets)

    print("\nDone.")
    print()
    print("Next: review posts, then you may optionally remove resources/images/archive/")
    print("if all image references are updated. But keeping it there is also fine for")
    print("backwards compatibility with old URLs.")


if __name__ == "__main__":
    main()
