---
title: "eXist 2.2.RC1"
date: 2014-02-19
author: "wolf"
tags:
  - "release"
status: published
migrated-from: AtomicWiki
original-id: "eXist22RC1"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/eXist22RC1"
---

We are very proud to announce the first release candidate for the next version of eXist, 2.2. The release candidate is feature complete, but not yet recommended for production use. Please let us know of any issues that you encounter so that
we may resolve any unexpected bugs and finalise the release within the next month or so.

eXist 2.2 provides a new Range Index, which can accelerate your XQuery code
and has proven to be upto 100 times faster than previous versions. This is the fastest release of eXist ever!

You can [download the release from sourceforge](http://sourceforge.net/projects/exist/files/Stable/2.2/).

# eXist 2.2.RC1

## New Range Index
2.2 features a reimplementation of the range index, the most important user-configurable index in eXist. As reported by users, some types of queries can run up to 100 times faster. The most dramatic performance increases have been observed on large data sets (with millions of documents) and queries on frequent strings. However, the new Lucene based index also brings many benefits for those working with smaller data sets.

While updates on the previous index system did not scale well with increasing collection sizes, the new index removes those limitations, thus allowing queries and updates to scale up. As previously reported by some users, problems with slow updates and increased memory usage have disappeared since switching to the new index.

Please refer to the [documentation](http://exist-db.org/exist/apps/doc/newrangeindex.xml) for more information.

## Improved Crash Recovery
The new version also features a largely rewritten and simplified crash recovery, leading to a more robust recovery procedure and smaller transaction logs.

## Security
eXist 2.2.RC1 further extends it's Unix permission model, and now includes setUid and setGid bits. This both allows stored XQuerys to escalate permissions and enables the controlled sharing of Collection documents with groups os users. This is extremely important as it now makes it possible to call a query as an unpriviledged user and have it switch to a different effective user without providing a target for attacks.

## Bug Fixes
2.2.RC1 includes numerous bug fixes, some of the highlights are:

* Crash Recovery - Exceptions during transaction rollback no longer cause the database recovery to be aborted; Previously this was commonly seen as `page not initialized` errors.
* Java Service Wrapper - No longer kills eXist if it takes longer than expected to shut down or start up.
* Concurrency - Removed consequtive query invocation lockups, and many other small fixes.
* Memory - Memory Leaks in the full text index were fixed.
* Optimizer - Now descends into XQuery Update expressions.
* Java Admin Client - It is no longer possible to accidentally lock out the admin user by mis-changing her password.
 