---
title: "Small Fixes in 1.2.2"
date: 2008-06-03
author: "wolf"
tags: []
status: published
migrated-from: AtomicWiki
original-id: "Release122"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/Release122"
---

This version fixes a few small, but annoying issues:

- the TimeoutCheck system job needed by the REST interface could not be intialized by the scheduler. This led to "SEVERE" warnings being displayed in the logs, which caused some irritations.

<!-- -->

- an XUpdate memory leak has been identified and fixed

<!-- -->

- a regression in the query engine led to duplicate attributes being created on the same element

<!-- -->

- the shutdown script now tried to display a dialog box to ask for the admin password. On a headless system, this would result in an exception though.
