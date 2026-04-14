---
title: "New Stable Release 1.2.1"
date: 2008-05-15
author: "wolf"
tags: []
status: published
migrated-from: AtomicWiki
original-id: "NewStableRelease"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/NewStableRelease"
---

In particular, an error in the computation of node ids caused database corruptions after repeatedly removing, then re-inserting nodes into a document tree. This bug has been around for a while. Applications which rely on XUpdate or XQuery update extensions should be updated to the new version!

We also fixed a few performance issues, including problems introduced by the new XQuery optimizer. Concerning concurrency, a bug in the locking code could considerably slow down eXist in a multi-user environment, and another issue led to the infamous and usually fatal "document id and proxy id differ" errors, which were reported by users. 1.2.1 also features a new [consistency check tool](/blogs/eXist/ConsistencyChecker), which should help to detect and fix errors earlier.

A detailed change log is available:

[]()
