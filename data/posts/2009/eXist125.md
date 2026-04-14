---
title: "eXist 1.2.5 Released"
date: 2009-02-25
author: "wolf"
tags: []
status: published
migrated-from: AtomicWiki
original-id: "eXist125"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/eXist125"
---

We are happy to announce that eXist 1.2.5 is now available for download. Like all releases in the 1.2.x series, version 1.2.5 is a bug fix and stability release. It only contains hand-selected changes, which have been tested in production. Updating is recommended.

The 1.2.5 release addresses a number of major problems and deficiencies. These include, among other things:

- attribute values larger than 4K could lead to index failures
- concurrency issues/access conflicts caused queries to fail unpredictably and sometimes damaged the db
- xmlrpc interface was responsible for memory issues and limited parallel connections; major update of the xmlrpc libs and interfaces
- bugs in crash recovery; improved shutdown/startup process to avoid unnecessary, sometimes fatal recovery runs
- new web interface for monitoring queries/running operations
- updated SOAP libraries to fix memory issues

We would now like to finalize 1.3, which will be based on the current SVN trunk. However, I will continue to maintain the 1.2.x branch, so it is possible that there will be a 1.2.6 release in addition to 1.3.

Special thanks to Dannes who spent a weekend with me (Wolfgang) to get the release ready.
