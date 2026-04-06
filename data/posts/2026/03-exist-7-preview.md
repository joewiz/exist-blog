---
title: "eXist-db 7.0 Preview: What's Coming"
date: 2026-03-26
author: Joe Wicentowski
tags: [release, xquery-4, performance]
category: releases
summary: "A look at the major features shipping in eXist-db 7.0, including XQuery 4.0 support, performance improvements, and new developer tools."
status: published
---

# eXist-db 7.0 Preview

The next major release of eXist-db brings significant improvements across the board. Here's a preview of what's coming.

## XQuery 4.0 Support

eXist-db 7.0 ships with support for key XQuery 4.0 features, including the arrow operator and new built-in functions:

```xquery
(1, 2, 3) -> fn:sum()
```

[Try it](/exist/apps/sandbox/?query=(1,2,3)->fn:sum())

## Performance Improvements

The storage engine has been optimized for better throughput on large collections. Index operations are now up to 3x faster on bulk inserts.

## New Developer Tools

- **Dashboard rewrite** — The admin dashboard has been rebuilt with Jinks templates and site-shell integration
- **Improved LSP** — The eXist-db Language Server now supports completions for imported module functions
- **Sandbox notebooks** — Interactive XQuery notebooks with live execution

## Migration Guide

Upgrading from eXist-db 6.x should be straightforward. The main breaking changes are:

1. Java 21 is now required (was Java 11)
2. The `compression` module has been replaced with the EXPath `zip` module
3. Legacy `xmldb:*` functions are deprecated in favor of the EXPath `file` module

Check the [full migration guide](/exist/apps/doc/upgrading) for details.
