---
title: "What do you mean by *value* index?"
date: 2009-04-18
author: dmitriy
tags: []
status: published
migrated-from: AtomicWiki
original-id: Whatdoyou
original-url: https://exist-db.org/exist/apps/wiki/blogs/eXist/FAQ/Whatdoyou
---


# NOTE: This post was auto-migrated from AtomicWiki and may need manual review.

Question: What do you mean by value index? Answer: A "value" or "range" index supports standard comparisons with =, &amp;#x3e;, &amp;#x3c; and the like. In short, the structural index helps with the expression collection("/db")/doc/attribute/rut_afiliado but you will also need a range index to speed up the value lookup on rut_afiliado: rut_afiliado[]() Folow reading: []()