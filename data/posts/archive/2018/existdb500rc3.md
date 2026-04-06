---
title: "eXist-db 5.0.0 RC 3"
date: 2018-08-01
author: wolf
tags: [release, article]
category: release, article
status: published
migrated-from: AtomicWiki
original-id: eXistdb500RC3
original-url: https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb500RC3
---

## v5.0.0-RC3 - August 1, 2018

The third Release Candidate (RC) for eXist-db 5.0.0 has been released.

eXist-db 5.0.0-RC3 builds atop eXist-db [5.0.0-RC2](http://www.exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb500RC2) with a just one new feature, and several small but important bug fixes.

* **NOTE**: A Release Candidate is not recommended for production use. We have tested the release extensively, and we now invite all users to report both their positive and negative experiences with it. As always please make sure you have frequent and correct backups of your database.


### Features

* Added a build target for a .tar.bz2 distribution.


### Bug fixes

* Fixed a problem with Backups performed via the XML:DB Remote API.

* Fixed a problem where Shutdown on Windows was prevented by the Lock Table event processor.

* Fixed a problem with variables used by the IzPack installer for the Java Service Wrapper.

* Fixed a problem with quotes in Windows paths used in the IzPack installer.

* Made sure that the IzPack installer checks for Java 8.

* Updated the function documentation for scheduling jobs via XQuery to reflect that they are not persistent across database restarts.

* Fixed the IzPack description in build.properties.

* Improved the logging in the Plugins Manager.


### Backwards Compatibility
eXist-db 5.0.0-RC3 is backwards compatible up to eXist-db 5.0.0-RC1. For details of backwards compatibility with versions of eXist-db prior to 5.0.0-RC1 please see the [*Backwards Compatibility* details of 5.0.0-RC1](http://www.exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb500RC1).


### Downloading this Version
* eXist-db v5.0.0-RC3 is available for download from [GitHub](https://github.com/eXist-db/exist/releases/tag/eXist-5.0.0-RC3).
* Docker images for are available from eXist-db's [DockerHub](https://hub.docker.com/r/existdb/existdb/tags/).
* Maven artifacts are available from our [mvn-repo](https://github.com/eXist-db/mvn-repo).
* Mac users of the [Homebrew](http://brew.sh) package repository may acquire eXist 5.0.0-RC3 directly from there via. the `exist-db-rc` cask.