---
title: "Design size of Collections"
date: 2008-08-22
author: "Wolfgang Meier"
tags:
  - "howto"
status: published
migrated-from: AtomicWiki
original-id: "CollectionSize"
original-blog: "HowTo"
original-url: "https://exist-db.org/exist/apps/wiki/HowTo/CollectionSize"
---

# What is the optimal number of documents in a collection?

With current eXist versions you have to find a compromise between query speed and update costs: storing all documents into a single collection results in fast queries. The drawback is that removing or replacing documents can become really slow! On the other hand, using one collection per document would guarantee that document updates run in linear time, but the query overhead would be considerable.

So if you need reasonable fast updates, the recommendation is to keep the number of documents in one collection below 2000 or so. Otherwise, if you never delete documents, you can easily store some 100,000 docs into one collection.

We plan to redesign the current index organization in the coming months.