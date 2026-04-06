---
title: "eXist-db 2.2RC2"
date: 2014-07-23
author: editor
tags: [release]
category: release
status: published
migrated-from: AtomicWiki
original-id: eXist22RC2
original-url: https://exist-db.org/exist/apps/wiki/blogs/eXist/eXist22RC2
---

The second release candidate for eXist 2.2 is available for [download](http://sourceforge.net/projects/exist/files/Stable/2.2/).

RC2 contains numerous bug fixes, enhancements and performance improvements. The new range index - introduced with RC1 - has seen a lot of real-world testing and bug fixing to make sure it is properly used by queries, so they benefit from the superior performance of this new index.


Beyond the new range index, a number of other performance bottlenecks have been identified. Each of those can have a huge effect on particular queries: for example, the removal of unnecessary type checks on index-assisted functions and redundant cleanup cycles in the query engine increased performance in some cases by factor 10 or more. NGram indexes have also seen a huge speed up with respect to indexing as well as query times. Finally, the query optimizer missed to descend into some types of expressions, causing them to run without optimization.

<figure class="wysiwyg-float-right" style="margin-bottom:30px;">
    <img src="/exist/apps/blog/resources/images/archive/sarit.png"/>
    <figcaption style="border:none;">Using the NGram index to search Sanskrit texts</figcaption>
</figure>

Noteworthy other changes include, but are not limited to:

* Fix: a caching issue led to random index failures for data sets large enough to fill the entire caching space.
* Fix: faster addition or insertion of nodes using update extensions. In particular, the time to append a node should not increase with the size of the document anymore.
* Fix: removing a collection containing a large number of documents or subcollections resulted in a huge recovery log being written, which does not only consume disk space, but may eventually also lead to recovery failures.
* Enhancement: faster consistency checks and thus backups.
* Enhancement: allow queries to be terminated by user: now effectively stops all types of expressions that have blocked db shutdown before.



<figure class="wysiwyg-float-left">
    <img src="/exist/apps/blog/resources/images/archive/profiling.png"/>
    <figcaption style="border:none;">Query profiling with Monex</figcaption>
</figure>

<p style="margin-left:50%">
Nearly all apps shipping with eXist have been enhanced as well. There were so many changes and additions that we will need to cover them in a separate article during the next days, so please stand by.</p>

<p style="margin-left:50%">
The final release of eXist 2.2 is scheduled for the first half of August.</p>