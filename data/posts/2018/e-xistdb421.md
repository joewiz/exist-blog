---
title: "eXist-db 4.2.1"
date: 2018-06-14
author: "wolf"
tags:
  - "release"
  - "article"
status: published
migrated-from: AtomicWiki
original-id: "eXistdb421"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb421"
---

## v4.2.1 - June 14, 2018

eXist-db v4.2.1 has just been released. This is a hotfix release, which contains bug fixes for several important issues discovered since eXist-db v4.2.1.

We recommend that all users of eXist 4.2.0 should upgrade to eXist 4.2.1.

### Bug fixes
* Fixed an NPE with XQuery Update insert preceding with attributes. Closes [#1761](https://github.com/eXist-db/exist/issues/1761) and [#1939](https://github.com/eXist-db/exist/issues/1939).

* Only attributes which are considered boolean in HTML5 have their values omitted. Closes [#777](https://github.com/eXist-db/exist/issues/777). Thanks to [Bert Willems](https://github.com/devatwork) from [FontoXML](https://fontoxml.com/) for this fix.

* Fixed an issue with the XQuery function `inspect:module-functions`, which was previously throwing a NPE. Closes [#1927](https://github.com/eXist-db/exist/issues/1927).

* Fixed an issue with restoring Compressed (Zip) database backups. Closes Closes [#1913](https://github.com/eXist-db/exist/issues/1913).


### Backwards Compatibility

* eXist-db v4.2.1 is backwards binary-compatible as far as v3.0, but not with earlier versions. Users who are upgrading should always consult the [Upgrading Guide](http://exist-db.org/exist/apps/doc/upgrading.xml) in the documentation.

* **NOTE**: The version of Dashboard that was installed with eXist-db 3.6.1 (or earlier) is incompatible with eXist-db 4.0.0 and newer. If you plan to migrate your entire database to eXist-db 4.2.1, you **MUST** take one of the following steps to allow Dashboard to work after the upgrade:

    1. If you have not yet installed eXist-db 4.2.1, open `Dashboard > Package Manager`, and upgrade Dashboard to `0.4.10`, or run this script in eXide or the Java Admin Client: `repo:install-and-deploy("http://exist-db.org/apps/dashboard", "http://demo.exist-db.org/exist/apps/public-repo/modules/find.xql")`. Then you may safely install eXist-db 4.2.1 and use Dashboard.
    
    2. If you install eXist-db 4.2.1 before upgrading Dashboard, run this script in eXide or the Java Admin Client: `repo:install-and-deploy("http://exist-db.org/apps/dashboard", "http://demo.exist-db.org/exist/apps/public-repo/modules/find.xql")`. Then you may use Dashboard.


### Downloading This Version
* eXist-db v4.2.1 is available for download from [GitHub](https://github.com/eXist-db/exist/releases/tag/eXist-4.2.1).
* Docker images for are available from EvolvedBinary's [DockerHub](https://hub.docker.com/r/evolvedbinary/exist-db/tags/).
* Maven artifacts are available from our [mvn-repo](https://github.com/eXist-db/mvn-repo).
* Mac users of the [Homebrew](http://brew.sh) package repository may acquire eXist 4.2.1 directly from there.