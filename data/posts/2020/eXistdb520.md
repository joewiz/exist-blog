---
title: "eXist-db 5.2.0"
date: 2020-01-23
author: "aretter"
tags:
  - "release"
  - "article"
status: published
migrated-from: AtomicWiki
original-id: "eXistdb520"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb520"
---

# v5.2.0 - January 23rd, 2020

We are very happy to announce that eXist-db 5.2.0 has been released.

5.2.0 is a minor release, and as such should be 100% API compatible
with 5.0.0. Whilst this is a fairly conservative release, it fixes two
critical issues:

1. We fixed a concurrency issue in the reuse of hot Locks which could
appear under high-load and cause a transaction to error and abort.
This issue is present in all eXist-db 5.x.x versions prior to 5.2.0,
but not 4.7.1. This issue could cause corruption in a <5.2.0 system.

2. We fixed a live-lock in the Transaction Manager which
could appear under high-load and prevent a transaction from completing.
This issue is present in all eXist-db 5.x.x version prior to 5.2.0,
but not 4.7.1. This issue could cause a <5.2.0 system to eventually lock-up.

## Features
* Implemented the XQuery function `array:put`
[#3092](https://github.com/eXist-db/exist/pull/3092)
* Implemented the XQuery function `fn:json-to-xml`
[#3093](https://github.com/eXist-db/exist/pull/3093)
* Facility to have Document locks use the same hierarchical path based
locking as Collection locks
[#3208](https://github.com/eXist-db/exist/pull/3208)
* Allow an indexed node to be a member of multiple hierarchical facets at the same time [#3182](https://github.com/eXist-db/exist/pull/3182)
* Improved the performance of `FastStringBuffer`
[#3186](https://github.com/eXist-db/exist/pull/3186)
* Implemented `isOpen()` and `close()` methods on XML:DB API's
`RemoteCollection`
[#2881](https://github.com/eXist-db/exist/pull/2881)
* Improved log messages when disk space is exhausted
[#3127](https://github.com/eXist-db/exist/pull/3127)


## Bugfixes
* Fixed a livelock in the Transaction Manager
[#3156](https://github.com/eXist-db/exist/pull/3156)
* Fixed a Concurrency Issue in Lock Reuse
[#3219](https://github.com/eXist-db/exist/pull/3219)
* Fixed an issue where the wrong Lucene Index Config could of been
selected [#3142](https://github.com/eXist-db/exist/pull/3142)
* Fixed an NPE which prevented the Content Extraction Module from
functioning [#3206](https://github.com/eXist-db/exist/pull/3206)
* Fixed opening the Statistics Index
[#3201](https://github.com/eXist-db/exist/pull/3201)
* Fixed a Cast Exception in `fn:subsequence` on sequences with atomic
values [#3199](https://github.com/eXist-db/exist/pull/3199)
* Fixed a memory-leak when shutting down an instance; occurred when
there were multiple instances
[#3171](https://github.com/eXist-db/exist/pull/3171)
* Removed unused options in `conf.xml`
[#3127](https://github.com/eXist-db/exist/pull/3127)
* Removed extraneous logging of stack traces
[#3140](https://github.com/eXist-db/exist/pull/3140)
* Fixed log level of failed index lookups
[#3200](https://github.com/eXist-db/exist/pull/3200)
* Many small code improvements
[#3178](https://github.com/eXist-db/exist/pull/3178)


## Updated Libraries
* Apache Commons Codec 1.14 [#3189](https://github.com/eXist-db/exist/pull/3189)
* Apache HTTP Components 4.5.11
[#3213](https://github.com/eXist-db/exist/pull/3213)
* Apache Log4j 2.13.0 [#3162](https://github.com/eXist-db/exist/pull/3162)
* Apache Tika 1.23 [#3215](https://github.com/eXist-db/exist/pull/3215)
* Apache Xerces 2.12.1 [#3218](https://github.com/eXist-db/exist/pull/3218)
* Caffeine 2.8.1 [#3204](https://github.com/eXist-db/exist/pull/3204)
* Eclipse Jetty 9.4.26.v20200117
[#3211](https://github.com/eXist-db/exist/pull/3211)
* EXPath HTTP Client 1.2.2 [#3216](https://github.com/eXist-db/exist/pull/3216)
* EXQuery 0.1.35 [#3198](https://github.com/eXist-db/exist/pull/3198)
* Jackson 2.10.2 [#3188](https://github.com/eXist-db/exist/pull/3188)
* jcTools 3.0.0 [#3187](https://github.com/eXist-db/exist/pull/3187)
* jline 3.13.3 [#3190](https://github.com/eXist-db/exist/pull/3190)
* jUnit 4.13 [#3180](https://github.com/eXist-db/exist/pull/3180)
* lz4-java 1.7.1 [#3212](https://github.com/eXist-db/exist/pull/3212)
* rsyntaxtextarea 3.0.8 [#3181](https://github.com/eXist-db/exist/pull/3181)
* Saxon-HE 9.9.1-6 [#3150](https://github.com/eXist-db/exist/pull/3150)
* Slf4j API 1.7.30



## Backwards Compatibility
eXist-db 5.2.0 is binary compatible with previous eXist-db 5.x.x
versions back to 5.0.0-RC6.
Regardless, before upgrading to this version of eXist-db, it is
strongly recommended to perform a full backup and
restore. Users who are upgrading should always consult the [Upgrading
Guide](https://exist-db.org/exist/apps/doc/upgrading.xml) in the
documentation. For details of backwards compatibility with versions of
eXist-db prior to 5.0.0-RC6, please see the Backwards Compatibility
details of [5.0.0-RC6](http://www.exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb500RC6).


## Downloading this Version
* eXist-db v5.2.0 is available for download from
[GitHub](https://github.com/eXist-db/exist/releases/tag/eXist-5.2.0).
* Docker images are available from eXist-db's
[DockerHub](https://hub.docker.com/r/existdb/existdb/tags/).
* Maven artifacts are available from [Maven Central](https://search.maven.org/search?q=g:org.exist-db).
* Mac users of the [Homebrew](http://brew.sh) package repository may
acquire eXist 5.2.0 directly from there via. the `exist-db` cask.