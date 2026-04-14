---
title: "eXist-db 5.1.1"
date: 2019-12-07
author: "aretter"
tags:
  - "release"
  - "article"
status: published
migrated-from: AtomicWiki
original-id: "eXistdb511"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb511"
---

# v5.1.1 - December 6, 2019

This is a small hotfix release addressing a few important issues.

## Bug Fixes

* Fixed a NPE with XSL:FO when using Apache FOP
[#3126](https://github.com/eXist-db/exist/pull/3126)
* Fixed an issue with upgrading packages when restoring a backup
[#3129](https://github.com/eXist-db/exist/pull/3129)
* Fixed the implementation of `fn:format-number`
[#3130](https://github.com/eXist-db/exist/pull/3130)
* Fixed a shutdown issue when running multiple database instances
[#3145](https://github.com/eXist-db/exist/pull/3145)


## Updated Libraries
* Eclipse Jetty 9.4.24.v20191120
[#3124](https://github.com/eXist-db/exist/pull/3124)
* EXPath Pkg 1.4.2 [#3131](https://github.com/eXist-db/exist/pull/3131)
* jline 3.13.2 [#3132](https://github.com/eXist-db/exist/pull/3132)


### Backwards Compatibility

eXist-db 5.1.1 is binary compatible with eXist-db 5.1.0, 5.0.0,
5.0.0-RC8, 5.0.0-RC7, and 5.0.0-RC6. Regardless, before upgrading to
this version of eXist-db, it is strongly recommended to perform a full
backup and restore. Users who are upgrading should always consult the
[Upgrading Guide](https://exist-db.org/exist/apps/doc/upgrading.xml)
in the documentation. For details of backwards compatibility with
versions of eXist-db prior to 5.0.0-RC6, please see the Backwards
Compatibility details of
[5.0.0-RC6](http://www.exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb500RC6).


### Downloading this Version
* eXist-db v5.1.1 is available for download from
[GitHub](https://github.com/eXist-db/exist/releases/tag/eXist-5.1.1).
* Docker images for are available from eXist-db's
[DockerHub](https://hub.docker.com/r/existdb/existdb/tags/).
* Maven artifacts are available from [Maven Central](https://search.maven.org/search?q=g:org.exist-db).
* Mac users of the Homebrew package repository may acquire eXist 5.1.1
directly from there via. the exist-db cask.