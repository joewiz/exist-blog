---
title: "Another Old Problem is Solved: Processing In-Memory Fragments"
date: 2008-04-01
author: "wolf"
tags: []
status: published
migrated-from: AtomicWiki
original-id: "InMemoryFragments"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/InMemoryFragments"
---

<div>

Let me explain what I'm talking about: as you all know, XQuery has a rich set of features which allow us to construct and process new XML nodes within the query. eXist has always supported this without restrictions. However, there were performance issues. Take a simple example:

``` xquery
(document {<p>Hello</p>})/node()
```

If you set your log level to "debug", you will find a message similar to the following in the logs after executing above statement:

    18 Feb 2008 11:20:10,890 [main] DEBUG 
    (XQueryContext.java [storeTemporaryDoc]:2120) 
    - Stored: 116: /db/system/temp/2dafe9ede8278febefe2150667587a15.xml

What happened? eXist has silently transformed the in-memory document into a persistent document. In the example above, applying the /node() step to the in-memory document caused eXist to store a temporary fragment in the db. Why? Well, the concepts used by eXist for querying persistent documents could not be equally applied to documents which reside in memory. After all, eXist was designed as a database which operates on persistent data and eXist's rule of thumb is: "never load the DOM if you can avoid it".

Now, if a temporary fragment needs to be stored one or two times during a query, you will probably not even notice it. However, if you need to batch-process a large number of nodes, you can end up with lots of temporary fragments being created and deleted. This can cause a high load on the db and may have a negative effect on overall stability.

We always thought that fixing those issues would require a major redesign. Our first approach, started by Adam last year, indeed caused hundreds of changes everywhere and finishing it would have cost a lot of time. I launched a second attempt a few weeks back, which was much less ambitious. Actually, I just thought I could change the query engine to at least handle the most common expressions by directly operating on the in-memory DOM.

I finally ended up with a version that could process the complete XQuery test suite entirely on in-memory documents - achieving the same score (99.4%) as the version which runs on stored documents! Basically, the new code applies eXist's node numbering scheme to in-memory documents. The query engine can thus use the same logic on in-memory documents as it uses on persistent documents --- well, with some differences (no indexes!).

This new code has been available in the eXist-memproc branch for a while and has passed all tests so far. We thus decided to move it into trunk to get more people to test it in real-world scenarios. The code will certainly be available in the next 1.3 development release. If it proves to be stable enough, we may also consider to port it back to the 1.2 stable branch. But we definitely need more testers to decide.

</div>
