---
title: "eXist-db 4.3.0"
date: 2018-07-06
author: wolf
tags: [release, article]
category: release, article
status: published
migrated-from: AtomicWiki
original-id: eXistdb430
original-url: https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb430
---

## v4.3.0 - July 06, 2018

eXist-db v4.3.0 has just been released. This is a feature release,
which contains several new features and bug fixes.

We recommend that all users of eXist 4.x.x should upgrade to eXist 4.3.0.


### Features
* Upgraded to Apache Xerces 2.12.0. eXist-db now includes XML Schema 1.1 support.

* Improved the Remote XML:DB API "networking error" messages to be
more descriptive.

* Test errors are now summarised in XQSuite XML output.


### Bug fixes

* Fixed an issue where in-memory documents used in XQuery Update
insert expressions caused an NPE (NullPointerException).

* Fixed an issue where XQuery Error Codes were not correctly reported
under some circumstances.

* Fixed an issue with restoring binary files of zero bytes via the
XML-RPC and XML:DB Remote API.

* Fixed a signing issue with running eXist-db from the installer under Java 10.

* Fixed an issue when constructing in-memory documents with namespaces
via SAX parsers.

* Fixed an issue with namespaces when parsing external documents to
in-memory documents.

* Fixed an issue with namespaces when merging in-memory documents.

* Fixed a NPE when calling `map:get` for a non-existent key/value map pair.

* Fixed a NPE in `fn:data`.

* Fixes a NPE when converting empty sequences.


### Backwards Compatibility

* eXist-db v4.3.0 is backwards binary-compatible as far as eXist-db
v3.0, but not with earlier versions. Users who are upgrading should
always consult the [Upgrading
Guide](http://exist-db.org/exist/apps/doc/upgrading.xml) in the
documentation.

* **NOTE**: The version of Dashboard that was installed with eXist-db
3.6.1 (or earlier) is incompatible with eXist-db 4.0.0 and newer. If
you plan to migrate your entire database to eXist-db 4.3.0, you
**MUST** take one of the following steps to allow Dashboard to work
after the upgrade:

  1. If you have not yet installed eXist-db 4.3.0, open `Dashboard >
Package Manager`, and upgrade Dashboard to `0.4.10`, or run this
script in eXide or the Java Admin Client:
`repo:install-and-deploy("http://exist-db.org/apps/dashboard",
"http://demo.exist-db.org/exist/apps/public-repo/modules/find.xql")`.
Then you may safely install eXist-db 4.3.0 and use Dashboard.

  2. If you install eXist-db 4.3.0 before upgrading Dashboard, run
this script in eXide or the Java Admin Client:
`repo:install-and-deploy("http://exist-db.org/apps/dashboard",
"http://demo.exist-db.org/exist/apps/public-repo/modules/find.xql")`.
Then you may use Dashboard.


### Downloading This Version
* eXist-db v4.3.0 is available for download from
[GitHub](https://github.com/eXist-db/exist/releases/tag/eXist-4.3.0).
* Docker images are available from EvolvedBinary's
[DockerHub](https://hub.docker.com/r/evolvedbinary/exist-db/tags/).
* Maven artifacts are available from our
[mvn-repo](https://github.com/eXist-db/mvn-repo).
* Mac users of the [Homebrew](http://brew.sh) package repository may
acquire eXist 4.3.0 directly from there.