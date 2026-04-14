---
title: "eXist 3.0.RC1 available for download"
date: 2015-07-07
author: "editor"
tags:
  - "release"
status: published
migrated-from: AtomicWiki
original-id: "eXist30RC1"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/eXist30RC1"
---

It is our great pleasure to announce the first release candidate for eXist 3.0.

As always, the purpose of this release candidate is to collect
feedback on performance and compatibility. Whilst it is considered
feature complete, we would not yet recommend it for production
environments.

eXist 3.0.RC1 is the culmination of over 550 changes made in the last
six months. The main focus has been on fixing bugs, migrating to Java
8 and improving the performance of eXist. The move to Java 8 alone has
brought many internal improvements in eXist, enabling us to work with a
leaner and safer code base; resulting in better resource and lock
management, and improved performance for our users.


## New Features
* Support for [XQuery 3.1][1], including the array and map data types,
serialisation and JSON parsing
* Support for Braced URI Literals from XQuery 3.0
* Facility to boost attributes in the Lucene full text index
* eXist version detection for EXPath packages. Packages should
explicitly specify which versions of eXist they are compatible with;
eXist 2.2 is assumed by default.
* Prototype support for [Portable EXPath XQuery Extension Functions][3] written in Haxe


## Improved Performance
* Sequence type checking on recursive function parameters has been
drastically sped up
* Lucene full-text and range indexes have been switched to "near
realtime" behaviour. This improves query performance on frequently
updated documents
* Improved optimization of wildcard steps in path expressions, e.g.
prefix:* and *:name
* Better performance for util:eval
* Optimisation of fn:fold-left and fn:fold-right


## Mission Critical Bug Fixes

There have been numerous bug fixes and enhancements since eXist 2.2,
the most critical are:

* Patched a memory leak in the Java service wrapper that occurred on
certain Linux systems
* Solved a potential deadlock which manifested when storing XQuery
files into the database under certain conditions
* Fixed a memory leak when storing query results into the HTTP
session; Web applications making use of the HTTP session should now
consume less memory and scale further
* Fixed an occasional deadlock when shutting down the database
* Fixes to match highlighting with the Lucene full text index
* Lucene range index now correctly handles != comparisons


## Clean up and Refactoring
* Rewritten HTML5 Serializer
* Removed the legacy SOAP API and SOAP Server
* Removed the legacy Full Text Index
* Removed the Versioning extension; will be made available as a
separate app package.
* Rewritten XML:DB and XML-RPC APIs
* Updated to the latest version of RESTXQ
* Improved Java Admin Client document viewing and editing
* Clean up of eXist's Test suite
* Extensive internal refactoring to exploit new Java 8 features

## Backwards Compatibility issues
* eXist-3.0.RC1 is not binary compatible with previous version of
eXist; the on-disk database file format has been updated, users should
perform a full backup and restore to migrate their data.
* eXist 3.0.RC1 and subsequent versions now require Java 8; Users must
update to Java 8!
* Due to the legacy Full Text Index being removed, the `text` (`http://exist-db.org/xquery/text`) XQuery module has also been removed. Users should now look toward `fn:analyze-string`.
* There have been some small changes to some of the internal APIs.
e.g. XQueryService has been moved from DBBroker to BrokerPool.
* EXPath packages that incorporate Java libraries may no longer work
with eXist 3.0 and may need to be recompiled for our API changes;
packages should now explicitly specify the eXist versions that they
are compatible with.


eXist-3.0.RC1 is available for download from [GitHub][2]. The
older Sourceforge download page is no longer updated.
Maven artifacts for eXist-3.0.RC1 are available from our [mvn-repo][4].

[1]:    http://exist-db.org/exist/apps/wiki/blogs/eXist/XQuery31
[2]:    https://github.com/eXist-db/exist/releases/tag/eXist-3.0.RC1
[3]:    http://www.adamretter.org.uk/presentations/implementation-of-portable-expath-extensions_xml-london_20150607.pdf
[4]:    https://github.com/exist-db/mvn-repo