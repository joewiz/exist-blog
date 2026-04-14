---
title: "eXist-db 5.4.1"
date: 2022-02-09
author: "adam"
tags:
  - "release"
  - "article"
status: published
migrated-from: AtomicWiki
original-id: "eXistdb541"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb541"
---

# eXist-db 5.4.1 Release Notes

Version 5.4.1 is a small hotfix release for version 5.4.0. We recommend that all users of eXist-db 5.4.0 that use either WebDAV or Monex should immediately upgrade to eXist-db 5.4.1.

It incorporates just two important fixes. 

1. A regression was introduced in eXist-db 5.4.0 whereby XML documents were not correctly stored or copyable via WebDAV. This is now fixed in 5.4.1 by [#4231](https://github.com/eXist-db/exist/pull/4231)

2. A regression was introduced in eXist-db 5.4.0 whereby WebSocket support for Monex's console was disabled. This is now fixed in 5.4.1 by [#4221](https://github.com/eXist-db/exist/pull/4221)