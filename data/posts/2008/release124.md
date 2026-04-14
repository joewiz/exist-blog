---
title: "eXist 1.2.4 Released"
date: 2008-08-03
author: "wolf"
tags: []
status: published
migrated-from: AtomicWiki
original-id: "Release124"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/Release124"
---

<div>

Besides fixing critical bugs in the storage backend, the 1.2.4 release mainly improves the memory consumption of queries on large document sets. Major changes include:

- *new node set implementation*, which is much more memory efficient compared to previous approaches. The old implementation consumed a lot of memory when used with larger sets of documents. Obviously this had a negative effect on overall performance.

<!-- -->

- reduce *memory consumption of documents constructed during a query*: if you have a query which creates thousands of small XML fragments, each of those fragments used to have its own document context with its own name pool and various fields which may have never been needed. Large parts of the document context are now shared between fragments and we make more use of lazy initialization, thus reducing the memory consumption of in-memory fragments dramatically (in my tests, I could save up to 100mb memory when creating a few thousand XML fragments in one query).

<!-- -->

- fixed fatal *btree bugs* leading to index corruptions (which usually caused an ArrayIndexOutOfBounds exception). The bugs were more likely to occur when indexing large string keys, but they may also have happened in other situations. The failure damaged the index and rendered the db unusable (though it could be repaired).

<!-- -->

- fixed *concurrency issues* leading to ArrayIndexOutOfBounds or NoSuchElement exception when querying for attributes

<!-- -->

- *memory leak*: we observed that the xerces XML parser builds some internal data structures when validating a document, which are unfortunately not properly cleared afterwards. This is a major problem since eXist pools the XML parser instances. To work around those issues, eXist will no longer pool XML parsers which were used on larger documents.

<!-- -->

- using full text and ngram indexes at the same time caused eXist to hang in an *endless loop*

The release is now available for [download](http://exist-db.org/download.html).

Note: all releases in the 1.2 branch are bug fix releases and can be considered stable. They only contain hand-selected changes which were ported back from the main development version.

</div>
