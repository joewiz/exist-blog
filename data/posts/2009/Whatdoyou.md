---
title: "What do you mean by value index?"
date: 2009-04-18
author: "dmitriy"
tags:
  - "faq"
status: published
migrated-from: AtomicWiki
original-id: "Whatdoyou"
original-blog: "eXist/FAQ"
---

**Question: What do you mean by **value** index?**

Answer: A "value" or "range" index supports standard comparisons with =, \&#x3e;, \&#x3c; and the like. In short, the structural index helps with the expression

collection("/db")/doc/attribute/rut\_afiliado

but you will also need a range index to speed up the value lookup on rut\_afiliado:

rut\_afiliado

Folow reading: 
