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

Speaking of showing examples, what better way to demonstrate this than to share some new features of eXist 7! eXist-db 7.0 (currently in development as the `next-v2` branch) adds support for a wide range of [XQuery 4.0](https://qt4cg.org/specifications/xquery-40/xquery-40.html) features. Here are a few you can try right now.

### The pipeline operator

The [pipeline operator](https://qt4cg.org/specifications/xquery-40/xquery-40.html#id-pipeline-operator) (`->`) passes a value into an expression, binding it as the context item (`.`). This makes it easy to chain operations without deeply nested function calls:

```xquery
xquery version "4.0";

'a b c'
  -> tokenize(.)
  -> count(.)
  -> concat('count=', .)
```

### The `otherwise` clause

[`otherwise`](https://qt4cg.org/specifications/xquery-40/xquery-40.html#id-otherwise) returns the left operand if it is a non-empty sequence, or the right operand if it is empty — a concise alternative to `if (exists($x)) then $x else $default`:

```xquery
xquery version "4.0";

let $doc := <item price="10.00"/>
return
    $doc/@price - ($doc/@discount otherwise 0)
```

### CSV parsing

XQuery 4.0 adds [`fn:parse-csv()`](https://qt4cg.org/specifications/xpath-functions-40/Overview.html#func-parse-csv) for parsing CSV data directly. With the `header` option, the first row becomes column names accessible via the `get` function:

```xquery
xquery version "4.0";

let $input := string-join(
    ("name,city", "Bob,Berlin", "Alice,Aachen"),
    "&#xA;"
)
let $result := fn:parse-csv($input, { "header": true() })
return (
    $result?get(1, "name"),
    $result?get(2, "city")
)
```

---

The blog is open source — posts, styles, and application code are all in the [joewiz/exist-blog](https://github.com/joewiz/exist-blog) repository on GitHub. Contributions and feedback welcome.
