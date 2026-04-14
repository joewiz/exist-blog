---
title: "Welcome to the eXist-db Blog"
date: 2026-04-14
author: "joewiz"
tags:
  - "news"
  - "xquery-4"
status: published
---

Welcome to the new eXist-db blog. This site has two purposes.

The first is to preserve the archive of posts from **AtomicWiki** — the original eXist-db blog, which ran from 2007 to 2026 on the eXist-db website. Those 121 posts document the project's history: release announcements, feature introductions, tutorials, and community news. They've been migrated here so they remain accessible and searchable.

The second is to serve as a home for **new posts** about eXist-db: release announcements, technical articles, community news, and anything else worth sharing. If you've used eXist-db, built something with it, or have something to contribute to the community, we'd love to hear from you.

## What this blog can do

Posts are written in **Markdown** and stored as plain text files in a git repository. That means:

- Standard headings, lists, emphasis, and links
- Fenced code blocks with syntax highlighting
- Images stored alongside the posts that reference them

One feature worth highlighting: **fenced XQuery code blocks can be run interactively** — the same live evaluation that powers [Notebook](/exist/apps/notebook/) and the code cells on the eXist-db website. Here's a simple example:

```xquery
xquery version "3.1";

let $greet := function($name as xs:string) as xs:string {
    "Hello, " || $name || "!"
}
return $greet("eXist-db community")
```

## XQuery 4.0 in eXist-db 7.0

eXist-db 7.0 (currently in development as the `next-v2` branch) adds support for a wide range of [XQuery 4.0](https://www.w3.org/TR/xquery-40/) features. Here are a few you can try right now.

### The arrow operator

The arrow operator (`->`) pipes a value into a function call, with the left-hand value inserted as the first argument. This makes it easy to chain operations without deeply nested function calls:

```xquery
xquery version "4.0";

"  Hello, World!  "
  -> fn:normalize-space()
  -> fn:lower-case()
  -> fn:tokenize("\s+")
  -> fn:string-join(", ")
```

### The `otherwise` operator

`otherwise` returns the left operand if it is a non-empty sequence, or the right operand if it is empty — a concise alternative to `if (exists($x)) then $x else $default`:

```xquery
xquery version "4.0";

let $config := map { "timeout": 30 }
let $timeout := $config?timeout otherwise 60
let $retries := $config?retries otherwise 3
return
    "timeout=" || $timeout || ", retries=" || $retries
```

### String templates

String templates let you embed expressions directly in strings using backtick syntax, without needing string concatenation or `fn:format-string()`:

```xquery
xquery version "4.0";

let $release := map { "version": "7.0", "codename": "next-v2" }
return
    `eXist-db {$release?version} ({$release?codename}) — built on XQuery 4.0`
```

### `for member` over arrays

XQuery 4.0 adds `for member` to iterate directly over array members, complementing the existing `for $x in array:members($arr)` pattern:

```xquery
xquery version "4.0";

let $features := ["arrow operator", "otherwise", "string templates", "for member"]
return
    for member $f in $features
    return "- " || $f
```

---

The blog is open source — posts, styles, and application code are all in the [joewiz/exist-blog](https://github.com/joewiz/exist-blog) repository on GitHub. Contributions and feedback welcome.
