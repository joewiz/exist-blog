---
title: "eXist-db 5.0.0 RC6"
date: 2019-02-20
author: "admin"
tags:
  - "release"
  - "article"
status: published
migrated-from: AtomicWiki
original-id: "eXistdb500RC6"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb500RC6"
---

## v5.0.0-RC6 - February 19, 2019

The sixth Release Candidate (RC) for eXist-db 5.0.0 has been released.

eXist-db 5.0.0-RC6 builds atop eXist-db [5.0.0-RC5](http://www.exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb500RC5) with several new features and important bug fixes.

* **NOTE**: A Release Candidate is not recommended for production use. We have tested the release extensively, and we now invite all users to report both their positive and negative experiences with it. As always please make sure you have frequent and correct backups of your database.


### Features
* New De-duplicating BLOB store for binary documents - see [https://blog.adamretter.org.uk/blob-deduplication/](https://blog.adamretter.org.uk/blob-deduplication/)
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

eXist-db 5.0.0-RC5 is not binary compatible with previous versions of eXist-db (including earlier 5.0.0 Release Candidates) because of new BLOB Store, which required changes to the collections.dbx and Journal. Before upgrading to this version of eXist-db, you **MUST** perform a full backup and restore. Users who are upgrading should always consult the [Upgrading Guide](https://exist-db.org/exist/apps/doc/upgrading.xml) in the documentation. For details of backwards compatibility with versions of eXist-db prior to 5.0.0-RC1 please see the [*Backwards Compatibility* details of 5.0.0-RC1](http://www.exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb500RC1).


### Downloading this Version
* eXist-db v5.0.0-RC6 is available for download from [GitHub](https://github.com/eXist-db/exist/releases/tag/eXist-5.0.0-RC6).
* Docker images for are available from eXist-db's [DockerHub](https://hub.docker.com/r/existdb/existdb/tags/).
* Maven artifacts are available from our [mvn-repo](https://github.com/eXist-db/mvn-repo).
* Mac users of the [Homebrew](http://brew.sh) package repository may acquire eXist 5.0.0-RC6 directly from there via. the `exist-db-rc` cask.