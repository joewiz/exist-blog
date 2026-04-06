---
title: "eXist-db 4.7.0"
date: 2019-05-20
author: admin
tags: [release, article]
category: release, article
status: published
migrated-from: AtomicWiki
original-id: eXistdb470
original-url: https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb470
---

# v4.7.0 - May 19, 2019

This release closes a major memory leak introduced in 4.6.0, removes a deadlock condition and fixes a number of bugs.

## Features

* Update to Tika version 1.20 for content extraction module and fix some related bugs
* Add in-memory buffer to solve performance issue accessing remote eXist via XML:DB API
* Update EXQuery RESTXQ to 0.1.34, fixes parsing issues with Accept and Content-Type HTTP headers

## Bug Fixes

* XML serializer leaking memory
* Fix deadlock: memory size from the collection does not need a READ_LOCK, it is an estimate anyway
* Test suite was not correctly reporting failing tests
* Fix ByteArrayPool and CharArrayPool memory leaks
* Fix problems with computed namespace construction
* When loading XQuery modules dynamically, declared global variables were not analyzed properly
* Switch out org.exist.util.hashtable implementation for FastUtil. eXist's implementations have problems with hash-collisions and chaining
* Allow for passing options for ft:search queries. This allows to perform leading-wildcard queries on computed index fields
* Fix arrow operator and higher order functions: context sequence passed incorrectly
* Fix broken XQuery Update for 'insert following'
* Fix ArrayOutOfBoundsException querying doc with enclosed expression and fn:id function
* Fix EXPath HTTP Client - Previously when override-media-type was set and a charset was specified, the charset was ignored
* Fix an issue introduced by PR #2367: a lucene index configured with a match attribute should only be created for nodes matching the path, not all descendant nodes

### Backwards Compatibility

eXist-db 4.7.0 is binary compatible with the 4.6.1 and 4.6.0 versions of eXist-db. Users who are upgrading should always consult the [Upgrading Guide](https://exist-db.org/exist/apps/doc/upgrading.xml) in the documentation.


### Downloading this Version
* eXist-db v4.7.0 is available for download from [GitHub](https://github.com/eXist-db/exist/releases/tag/eXist-4.7.0).
* Docker images for are available from eXist-db's [DockerHub](https://hub.docker.com/r/existdb/existdb/tags/).
* Maven artifacts are available from our [mvn-repo](https://github.com/eXist-db/mvn-repo).
* Mac users of the [Homebrew](http://brew.sh) package repository may acquire eXist 4.7.0 directly from there via. the `exist-db` cask.