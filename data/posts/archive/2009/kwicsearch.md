---
title: "Keyword Search Tutorial Featuring KWIC Display"
date: 2009-01-22
author: wolf
tags: []
status: published
migrated-from: AtomicWiki
original-id: KWICSearch
original-url: https://exist-db.org/exist/apps/wiki/blogs/eXist/KWICSearch
---


# NOTE: This post was auto-migrated from AtomicWiki and may need manual review.

Joe Wicentowski has added another excellent [tutorial](http://en.wikibooks.org/wiki/XQuery/Keyword_Search) to the XQuery wikibook. It shows how to develop a keyword search on multiple document types and how to display search results with highlighted *keywords in context* (*KWIC*). In particular the KWIC display should be interesting. It is based on XQuery code originally developed for the documentation search facility on the main eXist page and the wiki (see "Quick Search" box to the right). Contrary to earlier solutions, we no longer need complicated callback functions to extract the matches with surrounding text. Instead, all the processing is done in XQuery. This became possible thanks to recent improvements in the query engine (that's why you need an eXist version build from SVN). Joe's [tutorial](http://en.wikibooks.org/wiki/XQuery/Keyword_Search) guides you through a complete example. The [XQuery wikibook](http://en.wikibooks.org/wiki/XQuery) is a great resource for XQuery in general. Don't miss it.