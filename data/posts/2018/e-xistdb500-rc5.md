---
title: "eXist-db 5.0.0 RC5"
date: 2018-11-23
author: "admin"
tags:
  - "release"
  - "article"
status: published
migrated-from: AtomicWiki
original-id: "eXistdb500RC5"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb500RC5"
---

## v5.0.0-RC5 - November 21, 2018

The fifth Release Candidate (RC) for eXist-db 5.0.0 has been released.

eXist-db 5.0.0-RC5 builds atop eXist-db [5.0.0-RC4](http://www.exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb500RC4) with several new features and important bug fixes.

* **NOTE**: A Release Candidate is not recommended for production use. We have tested the release extensively, and we now invite all users to report both their positive and negative experiences with it. As always please make sure you have frequent and correct backups of your database.


### Features

* Added a facility for configuring the XML parser from `conf.xml`. This allows the user to specify various options. It is suggested to use the commented options in `conf.xml` to secure the parser from XML external entity attacks. - [#2146](https://github.com/eXist-db/exist/pull/2146)
* Updated to AspectJ 1.9.2 for improved Java 11 support - [#2237](https://github.com/eXist-db/exist/pull/2237)
* Added a checksum to the Journal for each entry to detect corruption - [#2256](https://github.com/eXist-db/exist/pull/2256)
* Added a checksum to the Journal for the content of binary documents - [#2265](https://github.com/eXist-db/exist/pull/2265)
* Improved the provenance of the XML:DB API dependency [#2264](https://github.com/eXist-db/exist/pull/2264)
* Improved the provenance of the EXPath Pkg Repo fork dependency - [#2286](https://github.com/eXist-db/exist/pull/2286)


### Bug fixes

* Fixed a startup failure affecting macOS under Java 11 -  [#2189](https://github.com/eXist-db/exist/pull/2189)
* Fixed an issue affecting mixed types in a subsequence - [#2197](https://github.com/eXist-db/exist/pull/2197)
* Fixed preemptive authentication in the EXPath HTTP Client - [#2209](https://github.com/eXist-db/exist/pull/2209)
* Fixed a concurrency issue in `ContextUpdateListener` [#2212](https://github.com/eXist-db/exist/pull/2212)
* Fixed map constructor to prevent duplicate keys - [#2215](https://github.com/eXist-db/exist/pull/2215)
* Fixed thread naming - [#2218](https://github.com/eXist-db/exist/pull/2218)
* Fixed several journaling and recovery issues for XML and binary documents -  [#2249](https://github.com/eXist-db/exist/pull/2249)
* Fixed an issue with lock lifetime when changing permissions - [#2245](https://github.com/eXist-db/exist/pull/2245)
* Fixed a regression with loading the XML:DB API jar via `bin/startup` - [#2270](https://github.com/eXist-db/exist/pull/2270)
* Fixed a verbose logging regression in `ExistSAXParserFactory` - [#2272](https://github.com/eXist-db/exist/pull/2272)
* Fixed a regreesion in the ExportGUI - [#2277](https://github.com/eXist-db/exist/pull/2277)
* Fixed an issue with RESTXQ not releasing binary file handles - [#2290](https://github.com/eXist-db/exist/pull/2290)
* Removed the 2GB log file limit for the Journal [#2294](https://github.com/eXist-db/exist/pull/2294)
* Fixed a signing issue affecting the Bouncy Castle library - [#2300](https://github.com/eXist-db/exist/pull/2300)


### Backwards Compatibility

eXist-db 5.0.0-RC5 is not binary compatible with previous versions of eXist-db (including earlier 5.0.0 Release Candidates) because of improvements to the on-disk journal format. Before upgrading to this version of eXist-db, you **MUST** perform a full backup and restore. Users who are upgrading should always consult the [Upgrading Guide](https://exist-db.org/exist/apps/doc/upgrading.xml) in the documentation. For details of backwards compatibility with versions of eXist-db prior to 5.0.0-RC1 please see the [*Backwards Compatibility* details of 5.0.0-RC1](http://www.exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb500RC1).


### Downloading this Version
* eXist-db v5.0.0-RC5 is available for download from [GitHub](https://github.com/eXist-db/exist/releases/tag/eXist-5.0.0-RC5).
* Docker images for are available from eXist-db's [DockerHub](https://hub.docker.com/r/existdb/existdb/tags/).
* Maven artifacts are available from our [mvn-repo](https://github.com/eXist-db/mvn-repo).
* Mac users of the [Homebrew](http://brew.sh) package repository may acquire eXist 5.0.0-RC5 directly from there via. the `exist-db-rc` cask.