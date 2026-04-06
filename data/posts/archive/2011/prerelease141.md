---
title: "Pre-release 1.4.1 rev14769"
date: 2011-06-22
author: dizzzz
tags: []
status: published
migrated-from: AtomicWiki
original-id: Prerelease141
original-url: https://exist-db.org/exist/apps/wiki/blogs/eXist/Prerelease141
---


# NOTE: This post was auto-migrated from AtomicWiki and may need manual review.

Today the development team released another pre-release version of eXist-db, rev14769. It contains a number of backports of "trunk". Highlights: - bugfix: NPE when serialization options param was zero length string. Port of rev 14690 - performance: Faster sequence constructors in XQuery: old code parsed (1, 2, 3) into (1, (2, 3)). Processing this recursively eventually caused a stack overflow and was slow. Port of rev 13874, rev 13875 - bugfix: Local XMLDB API set permissions on the wrong collection - looks like this is an old bug. Port of rev 14735 The revision can be downloaded as an installer [jar](http://sourceforge.net/projects/exist/files/Stable/1.4.1/eXist-setup-1.4.1dev-rev14769.jar/download), [exe](http://sourceforge.net/projects/exist/files/Stable/1.4.1/eXist-setup-1.4.1dev-rev14769.exe/download) and as a [war](http://sourceforge.net/projects/exist/files/Stable/1.4.1/exist-1.4.1dev-rev14769.war/download) file. Please share your experiences (bug reports, general feedback) on the exist-open mailinglist so we can release a final version soon!