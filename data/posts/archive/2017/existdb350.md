---
title: "eXist-db v3.5.0"
date: 2017-09-28
author: admin
tags: [release]
category: release
status: published
migrated-from: AtomicWiki
original-id: eXistdb350
original-url: https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb350
---

# Release Notes

## v3.5.0 - September 27, 2017

eXist-db v3.5.0 has just been released. This is a minor release, which contains several new features and bug fixes.

### Features

* Improvements to Core Level 1 DOM compliance.
* Implemented missing functions `fn:tokenize#1` and `fn:node-name#0`.
* Regular Expressions are now Cached (e.g. `fn:analyze-string`, `fn:matches`, `fn:replace`, `fn:tokenize` and `util:get-fragment-between`).
* Updated the EXPath HTTP Client:
	* Added support for non-chunked HTTP 1.1.
	* Pools connections to improve performance.
	* Added support for SNI (Server Name Identification).
	* Fixed DOM issues with namespace URI handling.
* Upgraded to Jetty 9.4.6.v20170531.
* Upgraded to Apache Tika 1.16.
* Upgraded to Apache FOP 2.2 and improve FO processor logging.
* Upgraded various dependencies to the latest versions (Caffeine, Apache Commons, j8fu, Jackson, Jing, Log4J, Quartz Scheduler, and Slf4j).
* The data directories and memory settings can now be templated via `build.properties`.

### Apps
The bundled applications of the Demo Apps, Documentation, eXide, Function Docs, and Monex have all been updated to the latest versions.

### Bug fixes
* Mixed-Content is now correctly serialized to JSON rather than skipped.
* Fixed a NullPointerException when updating an attribute on an element in the non-default namespace which had a Lucene index defined.
* Arrow operator now works correctly again in user defined functions.
* Fixed selection of Processing Instructions by target.
* Fixed a locking issue when writing temporary documents.
* Fixed a Transaction Closed log warning in the XML:DB API.
* Extensions are now also signed as part of the installer.
* Fixed an issue with quoted paths and white-space in Windows batch files.
* `Node#hasChildNodes` no longer includes attributes.
* Fixed parameter handling bugs in the functions `fn:tokenize#2`, and `fn:tokenize#3`.
* Fixed the handling of `q` and `x` regex flags for `fn:matches`, `fn:replace` and `fn:tokenize`.
* Fixed the `fn:local-name#0`, `fn:name#0` and `fn:namespace-uri#0` functions to correctly work with the context item.
* The embedded Jetty server now uses the JVM's temporary folder for temporary files.
* Fixed compatibility with Eclipse IDE project files.
* Corrected the description of the `xmldb:clear-lock` function.


### Backwards Compatibility

- eXist-db v3.5.0 is backwards binary-compatible as far as v3.0, but not with earlier versions. Users upgrading from previous versions should perform a full backup and restore to migrate their data.


### Downloading This Version

eXist-db v3.5.0 is available for download from [GitHub](https://github.com/eXist-db/exist/releases/tag/eXist-3.5.0). Maven artifacts for eXist-db v3.5.0 are available from our [mvn-repo](https://github.com/eXist-db/mvn-repo). Mac users of the [Homebrew](http://brew.sh) package repository may acquire eXist 3.5.0 directly from there.
