---
title: "Difference between &= and = operators"
date: 2009-04-18
author: "dmitriy"
tags:
  - "faq"
status: published
migrated-from: AtomicWiki
original-id: "%2626%3B%3Dand%3D"
original-blog: "eXist/FAQ"
---

**Question: If i understand correctly, the \&#x26;= version is using the lucene index. The = version is using the structural index.**

Answer: \&#x26;= is not using the lucene index, but eXist's own internal full text index (which is not as fast as the lucene implementation). The lucene index is a new feature and provides its own extension functions.
