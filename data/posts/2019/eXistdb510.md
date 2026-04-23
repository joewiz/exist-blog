---
title: "eXist-db 5.1.0"
date: 2019-11-18
author: "aretter"
tags:
  - "release"
  - "article"
status: published
migrated-from: AtomicWiki
original-id: "eXistdb510"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb510"
---

# v5.1.0 - November 18th, 2019

We are very happy to announce that eXist-db 5.1.0 has been released.

5.1.0 is a minor release, and as such should be 100% API compatible
with 5.0.0. Whilst this is a fairly conservative release, it fixes two
critical issues:

1. A security issue, whereby lesser priviledged users were incorrectly
granted access to descendant collections
[#3059](https://github.com/eXist-db/exist/pull/3059). This bug is
present in both eXist-db 4.7.1 (and older) and 5.0.0, and we strongly
recommend upgrading.

2. We fixed a Race Condition in the Lock Allocation Table
(`WeakLazyStripes`) where under high-load the Garabage Collection of
the old Locks would interfere with the creation of new locks. This
isssue is present in eXist-db 5.0.0 but not 4.7.1. This issue could
cause a 5.0.0 system to throw unexpected exceptions or lock-up.


## Features
*     Allow multiple transactions per broker
[#3034](https://github.com/eXist-db/exist/pull/3034)
*     Lucene index predicates now also support`[@attr != value]`
[#2992](https://github.com/eXist-db/exist/pull/2992)
*     Enhance optimisations for positional predicates
[#3075](https://github.com/eXist-db/exist/pull/3075)
[#3085](https://github.com/eXist-db/exist/pull/3085)
*     Some small improvements to the SQL Module
[#3081](https://github.com/eXist-db/exist/pull/3081)
*     Add classes supporting a `SAXSource` for included database
documents [#3076](https://github.com/eXist-db/exist/pull/3076)
*     Add support for `minimum-must-match` on Lucene BooleanQuery
[#3107](https://github.com/eXist-db/exist/pull/3107)


## Security
*     Fix a security issue with collection access
[#3059](https://github.com/eXist-db/exist/pull/3059)


## Bugfixes
*     Fix a race condition in `WeakLazyStripes`
[#3064](https://github.com/eXist-db/exist/pull/3064)
*     Avoid `ConcurrentModificationException` at shutdown
[#3113](https://github.com/eXist-db/exist/pull/3113)
*     Make sure that compiled queries are returned to the pool
[#3065](https://github.com/eXist-db/exist/pull/3065)
*     Prevent `ClassNotFoundException` for Document Triggers
[#2949](https://github.com/eXist-db/exist/pull/2949)
*     Fix a `StackOverflowError` caused by lost type into
[#3112](https://github.com/eXist-db/exist/pull/3112)
*     Fix inverted command line arg test in Java Admin Client
[#3010](https://github.com/eXist-db/exist/pull/3010)
*     Fix [`util:parse-html`]({docs}/functions/util/parse-html) missing dependency
[#3047](https://github.com/eXist-db/exist/pull/3047)
*     Avoid NPE when reporting error
[#3078](https://github.com/eXist-db/exist/pull/3078)
*     Read `webdav.properties` from the `etc` directory when available
[#3009](https://github.com/eXist-db/exist/pull/3009)
*     Cleanup `conf.xml` options
[#3015](https://github.com/eXist-db/exist/pull/3015)


## Updated Libraries
*     Apache Ant 1.10.7 [#3005](https://github.com/eXist-db/exist/pull/3005)
*     Apache Commons Configuration2 2.6
[#3020](https://github.com/eXist-db/exist/pull/3020)
*     Apache Commons Daemon 1.2.2
[#3037](https://github.com/eXist-db/exist/pull/3037)
*     Apache FOP 2.4 [#3095](https://github.com/eXist-db/exist/pull/3095)
*     Apache HTTP Components 4.5.10
[#3011](https://github.com/eXist-db/exist/pull/3011)
*     Apache HTTP Core 4.4.12
[#3002](https://github.com/eXist-db/exist/pull/3002)
*     Apache XML Graphics 2.4
[#3096](https://github.com/eXist-db/exist/pull/3096)
*     Bouncy Castle 1.64 [#3048](https://github.com/eXist-db/exist/pull/3048)
*     EasyMock 4.1 [#3098](https://github.com/eXist-db/exist/pull/3098)
*     Eclipse Jetty 9.4.21.v20190926 to 9.4.22.v20191022
[#3067](https://github.com/eXist-db/exist/pull/3067)
*     Hamcrest 2.2 [#3057](https://github.com/eXist-db/exist/pull/3057)
*     Jackson 2.10.1 [#3099](https://github.com/eXist-db/exist/pull/3099)
*     Jakarta Mail 1.6.4 [#2986](https://github.com/eXist-db/exist/pull/2986)
*     jline 3.13.1 [#3073](https://github.com/eXist-db/exist/pull/3073)
*     JMH 1.22 [#3091](https://github.com/eXist-db/exist/pull/3091)
*     Quartz 2.3.2 [#3068](https://github.com/eXist-db/exist/pull/3068)
*     rsyntaxtextarea 3.0.4 [#3028](https://github.com/eXist-db/exist/pull/3028)
*     Saxon-HE 9.9.1-5 [#3006](https://github.com/eXist-db/exist/pull/3006)
*     Slf4j API 1.7.29 [#3082](https://github.com/eXist-db/exist/pull/3082)


## Backwards Compatibility
eXist-db 5.1.0 is binary compatible with eXist-db 5.0.0, 5.0.0-RC8,
5.0.0-RC7, and 5.0.0-RC6. Regardless, before upgrading to this version
of eXist-db, it is strongly recommended to perform a full backup and
restore. Users who are upgrading should always consult the [Upgrading
Guide](https://exist-db.org/exist/apps/doc/upgrading.xml) in the
documentation. For details of backwards compatibility with versions of
eXist-db prior to 5.0.0-RC6, please see the Backwards Compatibility
details of [5.0.0-RC6](http://www.exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb500RC6).


## Downloading this Version
* eXist-db v5.1.0 is available for download from
[GitHub](https://github.com/eXist-db/exist/releases/tag/eXist-5.1.0).
* Docker images for are available from eXist-db's
[DockerHub](https://hub.docker.com/r/existdb/existdb/tags/).
* Maven artifacts are available from [Maven
Central](https://search.maven.org/search?q=g:org.exist-db).
* Mac users of the [Homebrew](http://brew.sh) package repository may
acquire eXist 5.1.0 directly from there via. the `exist-db` cask.