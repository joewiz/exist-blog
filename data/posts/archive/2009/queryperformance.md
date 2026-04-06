---
title: "Query performance"
date: 2009-04-18
author: dmitriy
tags: []
status: published
migrated-from: AtomicWiki
original-id: Queryperformance
original-url: https://exist-db.org/exist/apps/wiki/blogs/eXist/FAQ/Queryperformance
---


# NOTE: This post was auto-migrated from AtomicWiki and may need manual review.

Question: I am doing a performance test of query operation in eXist，and the result following showed time consumption for query about 10 records increases when the total number of all records stored in database increases. There is no indexes. Answer: Without an index, if your query involves a comparison, eXist has to do a full scan over all the relevant nodes in the database. The more data is in the db, the more nodes have to be scanned. Please check []() and create the proper indexes.