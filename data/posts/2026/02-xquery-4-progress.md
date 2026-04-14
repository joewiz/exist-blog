---
title: "XQuery 4.0 Implementation Progress"
date: 2026-02-15
author: Wolfgang Meier
tags: [xquery-4, development]
category: development
summary: "An update on the progress of XQuery 4.0 implementation in eXist-db, including maps, arrays, and the arrow operator."
status: published
---

# XQuery 4.0 Implementation Progress

Work on XQuery 4.0 support in eXist-db has been progressing steadily. Here's a summary of what's been implemented and what's still in progress.

## Completed Features

- **Arrow operator** (`->`) for function chaining
- **`otherwise` operator** for fallback values
- **Lookup operator** (`?`) for maps and arrays
- **String templates** using backtick syntax
- **`fn:format-number()`** updated to 4.0 spec

## In Progress

- **`switch` as an expression** — allowing switch in more contexts
- **Pattern matching** — `match` expressions
- **Variadic functions** — functions accepting variable argument counts

## Try It

You can test the implemented features in the [Notebook](/exist/apps/notebook/):

```xquery
let $data := map {
    "users": array {
        map { "name": "Alice", "role": "admin" },
        map { "name": "Bob", "role": "editor" }
    }
}
return $data?users?*[?role = "admin"]?name
```

Feedback welcome on the [eXist-db community forum](https://exist-db.org/community).
