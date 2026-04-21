---
title: "eXist-db 4.3.1"
date: 2018-07-24
author: "wolf"
tags:
  - "release"
  - "article"
status: published
migrated-from: AtomicWiki
original-id: "eXistdb431"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb431"
---

## v4.3.1 - July 24, 2018

eXist-db v4.3.1 has just been released. This is a hot-fix release, which contains several important bug fixes.

We recommend that all users of eXist-db 4.x.x should upgrade to eXist-db 4.3.1.


### Bug fixes

* Fixed a regression introduced in eXist-db 4.3.0, where the type conversion of non-empty XDM Sequences was incorrectly returning an empty sequence. This could lead to insufficient results being returned by an XQuery.

* Reverted Apache Xerces 2.12.0 to 2.11.0. This fixes a regression introduced in eXist-db 4.3.0, whereby Xerces 2.12.0 proved to be incompatible with betteForm. Apache Xerces 2.12.0 is available in eXist-db 5.0.0-SNAPSHOT, and will be available from eXist-db 5.0.0-RC2 onwards.

* Fixed another problem with uploading zero length binary files via. the XML:DB Remote API.

* Fixed a number of issues with the LDAP Security Realm:
	1. Ensure the authenticated LDAP context is reused.
	2. Always close and dispose of any LDAP context that we create.
	3. Fixed encoding of CN and DN names during LDAP searches.

* Fixed an issue where the XQuery function [`file:serialize`]({docs}/functions/file/serialize) could use the incorrect character encoding depending on which platform eXist-db was being executed on.

* Fixed a comparison problem with node equality in the DOM API exposed via. the XML:DB Local API.

* Fixed a `java.nio.file.Path` issue when loading eXist-db's `conf.xml` file from inside a classpath Jar file.

* Removed unnecessary error level logging of the XQuery [`fn:error`]({docs}/functions/fn/error) function.

* Fixed an issue with the error message for restoring permissions; Now the entire resource URI is shown.

* Fixed an initialise/reset issue with Internal Module XQuery variables. This fixed a regression introduced in eXist-db 3.5.0.

* Fixed a JavaEE dependency runtime issue with Java 11.

* Downloading of XAR files during the eXist-db build process is now more descriptive.


### Backwards Compatibility

* eXist-db v4.3.1 is backwards binary-compatible as far as eXist-db v3.0, but not with earlier versions. Users who are upgrading should always consult the [Upgrading Guide](http://exist-db.org/exist/apps/doc/upgrading.xml) in the documentation.

* **NOTE**: The version of Dashboard that was installed with eXist-db 3.6.1 (or earlier) is incompatible with eXist-db 4.0.0 and newer. If you plan to migrate your entire database to eXist-db 4.3.1, you **MUST** take one of the following steps to allow Dashboard to work after the upgrade:

    1. If you have not yet installed eXist-db 4.3.1, open `Dashboard > Package Manager`, and upgrade Dashboard to `0.4.10`, or run this script in eXide or the Java Admin Client: `repo:install-and-deploy("http://exist-db.org/apps dashboard", "http://demo.exist-db.org/exist/apps/public-repo/modules/find.xql")`. Then you may safely install eXist-db 4.3.1 and use Dashboard.

	2. If you install eXist-db 4.3.1 before upgrading Dashboard, run this script in eXide or the Java Admin Client: `repo:install-and-deploy("http://exist-db.org/apps/dashboard", "http://demo.exist-db.org/exist/apps/public-repo/modules/find.xql")`. Then you may use Dashboard.


### Downloading This Version
* eXist-db v4.3.1 is available for download from [GitHub](https://github.com/eXist-db/exist/releases/tag/eXist-4.3.1).
* Docker images are available from EvolvedBinary's [DockerHub](https://hub.docker.com/r/evolvedbinary/exist-db/tags/).
* Maven artifacts are available from our [mvn-repo](https://github.com/eXist-db/mvn-repo).
* Mac users of the [Homebrew](http://brew.sh) package repository may acquire eXist 4.3.1 directly from there.