---
title: "eXist-db v3.4.1"
date: 2017-08-16
author: "admin"
tags:
  - "release"
status: published
migrated-from: AtomicWiki
original-id: "eXistdb341"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb341"
---

# Release Notes

## v3.4.1 - August 16, 2017

eXist-db v3.4.1 has just been released. This is a hotfix release, which contains bug fixes for several important issues discovered since eXist-db v3.4.0.

We recommend that all users of eXist 3.4.0 should upgrade to eXist 3.4.1.

### Bug fixes
* Fixed a regression related to XQuery Module cleanup and `util:eval` which was introduced in eXist-db 3.4.0.
* Fixed the signing of the core Jar files (`start.jar`, `exist.jar`, and  `exist-optional.jar`). This is required for using the Java Admin Client via. Java WebStart.
* Corrected the argument parser in `ExportMain` which is used for some backup scenarios. Previously `ExportMain` would exit after startup with an error.
* Fixed removal of an existing backup directory when starting a backup from the Java Admin Client. Previously the directory would always have been deleted; even when the user chose to preserve it.
* `xs:base64Binary` and `xs:hexBinary` backing InputStreams which were cached to a file now `#mark(int)`/`#reset()` correctly after reading.
* Extraneous whitespace is now stripped from XQDoc output provided to the Inspection XQuery extension module.
* Corrected the dependency references in the NetBeans project files.

### Backwards Compatibility

- eXist-db v3.4.1 is backwards binary-compatible as far as v3.0, but not with earlier versions. Users upgrading from previous versions should perform a full backup and restore to migrate their data.


### Downloading This Version

eXist-db v3.4.1 is available for download from [GitHub](https://github.com/eXist-db/exist/releases/tag/eXist-3.4.1). Maven artifacts for eXist-db v3.4.1 are available from our [mvn-repo](https://github.com/eXist-db/mvn-repo). Mac users of the [Homebrew](http://brew.sh) package repository may acquire eXist 3.4.1 directly from there.
