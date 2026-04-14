---
title: "eXist-db 4.7.1"
date: 2019-08-13
author: "admin"
tags:
  - "release"
  - "article"
status: published
migrated-from: AtomicWiki
original-id: "eXistdb471"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb471"
---

# v4.7.1 - August 13, 2019

This is a bug fix release addressing some important issues. 

## Bug Fixes

* Disable a bad XQuery optimization affecting multi-step path expressions like /a/b//c[d = 123] with descendant axis step and range index defined on `c`. The main optimizations will still work.
* Java admin client kept files up to 64M in memory, resulting in out of memory errors during backup/restore. Limit the max size to 4M
* Fix for macOS startup without Oracle JDK 8
* eXist was leaking file handles when loading XQuery modules from an expath package
* Fix unattended installation, enable configurable data directory
* Java Admin Client should be able to change logged in account password via XML:DB Remote and re-connect
* Fix a couple of issues in LDAP

### Backwards Compatibility

eXist-db 4.7.1 is binary compatible with the 4.7.0, 4.6.1 and 4.6.0 versions of eXist-db. Users who are upgrading should always consult the [Upgrading Guide](https://exist-db.org/exist/apps/doc/upgrading.xml) in the documentation.


### Downloading this Version
* eXist-db v4.7.1 is available for download from [GitHub](https://github.com/eXist-db/exist/releases/tag/eXist-4.7.1).
* Docker images for are available from eXist-db's [DockerHub](https://hub.docker.com/r/existdb/existdb/tags/).
* Maven artifacts are available from our [mvn-repo](https://github.com/eXist-db/mvn-repo).
* Mac users of the [Homebrew](http://brew.sh) package repository may acquire eXist 4.7.1 directly from there via. the `exist-db` cask.