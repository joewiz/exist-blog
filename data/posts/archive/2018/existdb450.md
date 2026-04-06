---
title: "eXist-db 4.5.0"
date: 2018-11-23
author: admin
tags: [release, article]
category: release, article
status: published
migrated-from: AtomicWiki
original-id: eXistdb450
original-url: https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb450
---

## v4.5.0 - November 21, 2018

eXist-db v4.5.0 has been released.

This is a minor release, which contains a few new features and several bug fixes.

We recommend that all users of eXist-db 4.x.x should upgrade to eXist-db 4.5.0.


### Features

* Added a facility for configuring the XML parser from `conf.xml`. This allows the user to specify various options. It is suggested to use the commented options in `conf.xml` to secure the parser from XML external entity attacks. - [#2147](https://github.com/eXist-db/exist/pull/2147)
* Updated to AspectJ 1.9.2 for improved Java 11 support - [#2236](https://github.com/eXist-db/exist/pull/2236)
* Added a checksum to the Journal for each entry to detect corruption - [#2255](https://github.com/eXist-db/exist/pull/2255)
* Added a checksum to the Journal for the content of binary documents - [#2260](https://github.com/eXist-db/exist/pull/2260)
* Improved the provenance of the XML:DB API dependency [#2263](https://github.com/eXist-db/exist/pull/2263)
* Improved the provenance of the EXPath Pkg Repo fork dependency - [#2284](https://github.com/eXist-db/exist/pull/2284)


### Bug fixes

* Fixed a startup failure affecting macOS under Java 11 -  [#2187](https://github.com/eXist-db/exist/pull/2187)
* Fixed an issue affecting mixed types in a subsequence - [#2198](https://github.com/eXist-db/exist/pull/2198)
* Fixed preemptive authentication in the EXPath HTTP Client - [#2208](https://github.com/eXist-db/exist/pull/2208)
* Fixed a concurrency issue in `ContextUpdateListener` [#2211](https://github.com/eXist-db/exist/pull/2211)
* Fixed map constructor to prevent duplicate keys - [#2214](https://github.com/eXist-db/exist/pull/2214)
* Fixed thread naming - [#2216](https://github.com/eXist-db/exist/pull/2216)
* Fixed an NPE in the range index involving the `order by` clause - [#2221](https://github.com/eXist-db/exist/pull/2221)
* Fixed several journaling and recovery issues for XML and binary documents -  [#2241](https://github.com/eXist-db/exist/pull/2241)
* Fixed an issue with lock lifetime when changing permissions - [#2251](https://github.com/eXist-db/exist/pull/2251)
* Fixed a regression with loading the XML:DB API jar via `bin/startup` - [#2268](https://github.com/eXist-db/exist/pull/2268)
* Fixed a verbose logging regression in `ExistSAXParserFactory` - [#2273](https://github.com/eXist-db/exist/pull/2273)
* Fixed a regression in the ExportGUI - [#2275](https://github.com/eXist-db/exist/pull/2275)
* Fixed an issue with RESTXQ not releasing binary file handles - [#2289](https://github.com/eXist-db/exist/pull/2289)
* Removed the 2GB log file limit for the Journal [#2292](https://github.com/eXist-db/exist/pull/2292)
* Fixed a signing issue affecting the Bouncy Castle library - [#2298](https://github.com/eXist-db/exist/pull/2298)


### Backwards Compatibility

* eXist-db v4.5.0 is not binary compatible with previous versions of eXist-db because of improvements to the on-disk journal format. Before upgrading to this version of eXist-db, you **MUST** perform a full backup and restore. Users who are upgrading should always consult the [Upgrading Guide](https://exist-db.org/exist/apps/doc/upgrading.xml) in the documentation.

* **NOTE**: The version of Dashboard that was installed with eXist-db 3.6.1 (or earlier) is incompatible with eXist-db 4.0.0 and newer. If you plan to migrate your entire database to eXist-db 4.4.0, you **MUST** take one of the following steps to allow Dashboard to work after the upgrade:

    1. If you have not yet installed eXist-db 4.5.0, open `Dashboard > Package Manager`, and upgrade Dashboard to `0.4.10`, or run this script in eXide or the Java Admin Client: `repo:install-and-deploy("http://exist-db.org/apps dashboard", "http://demo.exist-db.org/exist/apps/public-repo/modules/find.xql")`. Then you may safely install eXist-db 4.5.0 and use Dashboard.

	2. If you install eXist-db 4.5.0 before upgrading Dashboard, run this script in eXide or the Java Admin Client: `repo:install-and-deploy("http://exist-db.org/apps/dashboard", "http://demo.exist-db.org/exist/apps/public-repo/modules/find.xql")`. Then you may use Dashboard.


### Downloading This Version

* eXist-db v4.5.0 is available for download from [GitHub](https://github.com/eXist-db/exist/releases/tag/eXist-4.5.0).
* Docker images are available from [DockerHub](https://hub.docker.com/r/existdb/existdb/tags/).
* Maven artifacts are available from our [mvn-repo](https://github.com/eXist-db/mvn-repo).
* Mac users of the [Homebrew](http://brew.sh) package repository may acquire eXist 4.5.0 directly from there.
