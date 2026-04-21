---
title: "eXist-db 5.0.0 RC 1"
date: 2018-06-14
author: "wolf"
tags:
  - "release"
  - "article"
status: published
migrated-from: AtomicWiki
original-id: "eXistdb500RC1"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb500RC1"
---

# Release Notes

## v5.0.0-RC1 - June 9, 2018

We are very excited to announce the first Release Candidate (RC) for eXist-db 5.0.0.

**NOTE**: A Release Candidate is not recommended for production use. We have tested the release extensively, and we now invite all users to report both their positive and negative experiences with it. As always please make sure you have frequent and correct backups of your database.

The core improvements to eXist-db's locking, concurrency, and transactions in 5.0.0-RC1 represent a huge amount of work contributed by [Evolved Binary](https://evolvedbinary.com). For in-depth information on these changes, see Evolved Binary's technical reports: [Locking and Cache Improvements for eXist-db](http://www.evolvedbinary.com/technical-reports/exist-db/locking-and-cache-improvements/) and [Asymmetrical Locking for eXist-db](http://www.evolvedbinary.com/technical-reports/exist-db/asymmetrical-locking/).

In eXist-db 5.0.0-RC1, all locking interactions have been redesigned and reimplemented from the ground up; a number of deadlock paths have been removed; and many operations have been redesigned to be thread-safe. The result is that eXist-db should exhibit better responsiveness under concurrent user operations. For example, because collection locks are now multi-read capable, re-indexing the database no longer blocks access to the collection being re-indexed. Users should notice improved responsiveness during such operations.

5.0.0-RC1 also contains some security fixes and bug fixes that necessitated API changes and thus were not suitable for the existing 4.x.x line.


### Highlights Include

* Hierarchical locking strategy for Collection locks.
* Centralised Lock Manager, which feeds a Lock Table for reporting to the user on lock leases and pending lock acquisitions (with JMX support).
* All bespoke locks have been removed and/or replaced with standard Java library locks.
* Managed Lock wrappers for ARM (Automatic Resource Management), to ensure locks are never left dangling.
* Most operations now exploit deadlock avoidance strategies.
* Asymmetrical locking between Collection and Document locks; Collection locks now have shorter leases.
* Collections now exploit read/write locking, rather than Mutex locking; multiple reads can happen in parallel.
* Complete rewrite of Collection Caching using Ben Mane's [Caffeine](https://github.com/ben-manes/caffeine) library.
* Reduced Transaction overhead, by reusing existing transactions.
* Updated Saxon for XSLT to 9.8.0-12.
* XQuery function signatures are more closely aligned to the W3C XQuery specification.
* [`util:eval-with-context`]({docs}/functions/util/eval-with-context) now offers a timeout argument.
* Copy APIs now offer a `preserve` flag, which behaves similarly to GNU cp's `--preserve` flag.
* Implemented simplified [`xmldb:copy-resource`]({docs}/functions/xmldb/copy-resource) and [`xmldb:copy-collection`]({docs}/functions/xmldb/copy-collection) functions.


### Security fixes

* Fixed some incorrectly relaxed owner and mode permissions on copied Collections and Documents. [#1888](https://github.com/eXist-db/exist/pull/1888).
* Fixed some incorrect ownership and mode problems with *chown* and *chmod* operations. [#1893](https://github.com/eXist-db/exist/pull/1893).


### Bug fixes

* The last used User and Group id's are no longer exported during a database Backup, nor are they read back from a Backup when Restoring. As such the format of the file `/db/system/security/config.xml` has changed. [#1858](https://github.com/eXist-db/exist/pull/1858).
* XML-RPC and XML:DB Remote APIs now use GZip encoding for streams and not Zip. This introduces a non-backwards compatible change to the XML-RPC API which also affects the Java Admin Client. [#1903](https://github.com/eXist-db/exist/pull/1903).
* Numerous erroneous locking states (see Evolved Binary's Technical Reports).


### Backwards Compatibility

1. The format of `/db/system/security/config.xml` has changed. You can restore Backups from previous versions of eXist-db. However, you cannot restore a Backup from eXist-db 5.0.0-RC1 to a previous version of eXist-db.

2. The XML-RPC API is not 100% backwards compatible with prior versions of eXist-db, particularly with regards to uploading/downloading documents. You should always use the correct version of the Java Admin Client with eXist-db.

3. Versions of the Dashboard App prior to version 1.1.0 are not compatible with eXist-db 5.0.0-RC1. If you wish to migrate from an older version of eXist-db, you must first update both the Shared Resources package and the Dashboard package on your existing eXist-db version to at least versions 0.6.0 and 1.1.0 respectively. If you are starting with a new clean install of eXist-db 5.0.0-RC1 you have nothing to worry about.

eXist-db v5.0.0-RC1 is backwards binary-compatible as far as v3.0, but not with earlier versions. Users who are upgrading should always consult the Upgrading Guide in the documentation.


### Downloading this Version
* eXist-db v5.0.0-RC1 is available for download from [GitHub](https://github.com/eXist-db/exist/releases/tag/eXist-5.0.0-RC1).
* Docker images for are available from EvolvedBinary's [DockerHub](https://hub.docker.com/r/evolvedbinary/exist-db/tags/).
* Maven artifacts are available from our [mvn-repo](https://github.com/eXist-db/mvn-repo).
* Mac users of the [Homebrew](http://brew.sh) package repository may acquire eXist 5.0.0-RC1 directly from there.