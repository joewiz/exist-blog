---
title: "eXist 1.2 Released"
date: 2008-01-16
author: "wolf"
tags: []
status: published
migrated-from: AtomicWiki
original-id: "Release12"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/Release12"
---

<div>

Let me highlight some of the major changes:

## Core features

The database core has seen quite some redesign. Behind the scenes, we spent a lot of time on concurrency issues. As a result, eXist's deadlock management has greatly improved. For example, circular wait conditions between collection and resource locks are now properly detected and resolved.

Node updates via XUpdate or XQuery update extensions have become a bit faster as well. Internally, eXist now uses StAX instead of DOM in many places, which leads to reduced memory consumption.

The most important change however is the index redesign: eXist now features a [modularized indexing architecture](NewIndexing), which is based on the concept of *pluggable index pipelines*. When storing or updating a document, the database core generates a stream of index events and passes it to a pipeline of external index plugins. It is up to the plugin to process the event stream and create efficient data structures for the type of data it handles. We created two new index plugins while implementing the design: first, an [n-gram index](http://exist-db.org/indexing.html#ngramidx), which helps with substring queries and searches on text in languages for which the full text index doesn't really work well. Second, there's a new [spatial index](http://exist-db.org/devguide_indexes.html#N1064E) which indexes GML geometries in the XML to enable spatial queries.

The redesigned index architecture is also tightly related to our second major change: the new [query-rewriting optimizer](NewIndexing)! This is still work in progress, in particular with respect to the range of expressions which can be optimized automatically. However, optimizations can already speed up queries on large data sets by factor 10 or more. To benefit from the improvements, please read the [blog article](NewIndexing) on indexing first.

The optimizer analyzes the query at compile time and injects optimization instructions (as XQuery pragmas) into optimizable code blocks. At runtime, these instructions help the query engine to select the most efficient evaluation sequence, assisted by the new index architecture. This approach opens a wide range of possibilities beyond those we have already implemented. More can be expected soon.

## General

We made some huge progress concerning XQuery standard conformance. The closer we got to the 100%, the harder it became to fix the remaining issues. According to the official XQuery test suite, eXist passes 99.4%, i.e. 14544 out of 14637 tests.

The possibility to store [catalog files](http://www.exist-db.org/validation.html#N10198) into the database adds another missing building block: it may just seem a small feature, but without it, working with DTDs and schemas has always been a bit difficult in eXist. Now catalogs can be stored in the db along with schema documents and DTDs. Using the new framework, it became much easier to have documents validated against a DTD or schema. And though eXist does not yet implement the XQuery validation instructions, it does provide a number of useful extension functions for the job.

The database can now also be configured to run [user-defined jobs](http://exist-db.org/configuration.html#N104C5) at given intervals or at a fixed time. This is particularly useful to schedule automatic backups. As a system task, the backup runs in exclusive mode to make sure that the db remains in a consistent state while the backup is in progress.

## Interfaces

Concerning interfaces, eXist now offers out-of-the-box support for the [Atom Publishing Protocol](http://exist-db.org/atompub.html). Our new [wiki/blog](AtomicWiki) is entirely based on this feature.

For debugging and diagnostics, eXist now provides access to various management interfaces via [JMX](http://exist-db.org/jmx.html). Right now, the interfaces are read-only and limited to caching and other server statistics. However, we plan to expose the entire configuration, thus allowing a dynamic reconfiguration of the db at runtime.

Also, there's a complete new API for those using the db in embedded mode only: the fluent API relies on Java 5 features to provide a very elegant and smooth design.

Finally, since some of you might be asking for XQJ (XQuery API for Java) support in eXist: our implementation is nearly ready, but we lacked the time to test it well enough to become part of this release. We will certainly upload another minor release once the XQJ branch has been merged into trunk and is sufficiently tested.

</div>
