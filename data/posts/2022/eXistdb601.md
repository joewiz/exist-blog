---
title: "eXist-db 6.0.1"
date: 2022-02-09
author: "adam"
tags:
  - "release"
  - "article"
status: published
migrated-from: AtomicWiki
original-id: "eXistdb601"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb601"
---

# eXist-db 6.0.1 Release Notes

Version 6.0.1 is a small hotfix release for version 6.0.0.

We recommend that all users of eXist-db 6.0.0 that use either WebDAV or Monex should immediately upgrade to eXist-db 6.0.1.

It incorporates just two important fixes:

1. A regression was introduced in eXist-db 5.4.0 whereby XML documents were not correctly stored or copyable via WebDAV. This is now fixed in 6.0.1 by [#4230](https://github.com/eXist-db/exist/pull/4230)

2. A regression was introduced in eXist-db 5.4.0 whereby WebSocket support for Monex's Console was disabled. This is now fixed in 6.0.1 by [#4215](https://github.com/eXist-db/exist/pull/4215)