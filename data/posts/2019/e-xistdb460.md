---
title: "eXist-db 4.6.0"
date: 2019-02-20
author: "admin"
tags:
  - "release"
  - "article"
status: published
migrated-from: AtomicWiki
original-id: "eXistdb460"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb460"
---

## v4.6.0 - February 19, 2019

eXist-db 4.6.0 has been released.

eXist-db 4.6.0 builds atop eXist-db [4.6.0](http://www.exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb460) with several new features and important bug fixes.


### Features
* New De-duplicationg BLOB store for binary documents - see https://blog.adamretter.org.uk/blob-deduplication/
* More elaborate XPath expressions in the Lucene index config of `collection.xconf` are now supported
* New non-blocking lock-free implementation of the Transaction Manager
* CData serialization now respects the `output:cdata-section-elements` option
* New XQuery function `util:eval-and-serialize` for dynamic XQuery evaluation and serialization.
* New XQuery function `util:binary-doc-content-digest` to retrieve a digest of a Binary Document 
* Adaptive serialization is now used for `fn:trace` and `util:log-*` functions
* Updated Jetty to version 9.4.14.v20181114
* Updated to JLine version 3
* Updated to XML:DB API 1.7.0


### Bug fixes
* Fixed Lucene term range queries
* Copying an XML Resource now correctly removes any nodes that it replaces
* Fixed a memory leak with XQuery serializers
* Fixed Garbage Collection churn issue with serialization
* Fixed Backup/Restore progress reporting
* XQuery Library Modules on the Java Classpath are now correctly resolved from the importing XQuery module
* Prevent a `NullPointerException` in `fn:unparsed-text-available`
* Collection permissions are now correctly prefixed 'c' in the Java Admin Client shell
* Fixed an `ArrayOutOfBoundException` with `array:get`
* Corrected the XPath Error Code for `array:get`
* Fixed text alignment of output in the Java Admin Client shell
* Fixed missing dependencies issue with the Java Admin Client when launched via WebStart
* When building from source, if required XAR packages are not available, the build will now fail.


### Backwards Compatibility

eXist-db 4.6.0 is not binary compatible with previous versions of eXist-db (including earlier 4.5.x releases) because of new BLOB Store, which required changes to the collections.dbx and Journal. Before upgrading to this version of eXist-db, you **MUST** perform a full backup and restore. Users who are upgrading should always consult the [Upgrading Guide](https://exist-db.org/exist/apps/doc/upgrading.xml) in the documentation.


### Downloading this Version
* eXist-db v4.6.0 is available for download from [GitHub](https://github.com/eXist-db/exist/releases/tag/eXist-4.6.0).
* Docker images for are available from eXist-db's [DockerHub](https://hub.docker.com/r/existdb/existdb/tags/).
* Maven artifacts are available from our [mvn-repo](https://github.com/eXist-db/mvn-repo).
* Mac users of the [Homebrew](http://brew.sh) package repository may acquire eXist 4.6.0 directly from there via. the `exist-db-rc` cask.