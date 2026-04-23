---
title: "eXist-db v3.2.0"
date: 2017-05-03
author: "admin"
tags:
  - "release"
  - "news"
status: published
migrated-from: AtomicWiki
original-id: "eXistdb320"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb320"
---

# Release Notes

## v3.2.0 - May 2, 2017

We are happy to announce the release of eXist-db v3.2.0. This is a minor release, which introduces a few small features and addresses a number of issues.


### New Features

- Added an IPRange Security Realm, to authorize users by IP address only. (Disabled by default)
- Added `--forking` and `--pidfile` options to startup scripts
- Added configuration options to `$EXIST_HOME/webapp/WEB-INF/web.xml` to disable XQuery and XUpdate execution via submission to the RESTServer.
- Added the XPath 3.1 function [`fn:load-xquery-module`]({docs}/functions/fn/load-xquery-module)
- Added the XQuery function [`xmldb:find-last-modified-until`]({docs}/functions/xmldb/find-last-modified-until)

### Performance Improvements

- Small improvements to lock mode use; resulting in more shared locks, and less exclusive locks.
- Optimised `DefaultDocumentSet#contains` and `DefaultDocumentSet#equals` for `DefaultDocumentSet` comparisons

## Critical Bug Fixes
- Fixed the `following-sibling` axis so that it also correctly works with names. e.g. `$items//b/following-sibling::a`
- DataBackup scheduled tasks now includes all .dbx files and indexes
- Fixed missing transaction commit in EmbeddedUpload
- Several locking fixes, including lock acquire/release leaks

### Bug Fixes
- Fixed Lucene match highlighting of ignored nodes; when the ignored node had the same name as the indexed node.
- Fixed the implementation of `org.w3c.dom.Node#isSameNode` for persistent nodes; enables better compatibility when using database documents with Saxon.
- Fixed the reported line numbers when there are newlines in string literals or constructors
- Java Admin Client again correctly handles `--parse` or `-p` argument
- Namespace Constructor in Computed Element Constructor now works correctly
- Fixes to install and uninstall for the service wrapper (YAJSW) with systemd
- Fixes to resolving references in the Configurator
- Re-implement `CollectionConfiguration#triggerRegistered`; fixing the [xquery-versioning-module](https://github.com/eXist-db/xquery-versioning-module)
- `DefaultDocumentSet#contains` no longer always returns `true`
- Avoid implicit conversion of unicode `\x160` as numerical entity `&#160;` when serializing XML

### Clean Up and Refactoring
- Corrected the function documentation of [`xmldb:last-modified-since`]({docs}/functions/xmldb/last-modified-since)
- Disabled sequential token generation in the PersistentLoginModule
- Disabled auto-deployment of EXPath packages when running tests; faster test suite
- Switched from MBean to MXBeand for improved JMX client support
- Further legacy code cleanup to Java 8 syntax
- Upgraded 3rd party libraries:
    - log4j2 2.8.2
    - j8fu 1.4.1
- Generalised the MacOS package signing targets in the build system
- ... and many more 

### Backwards Compatibility

- eXist-db v3.2.0 is backwards binary-compatible as far as v3.0, but not with earlier versions. Users upgrading from previous versions should perform a full backup and restore to migrate their data.


### Downloading This Version

eXist-db v3.2.0 is available for download from [GitHub](https://github.com/eXist-db/exist/releases/tag/eXist-3.2.0). Maven artifacts for eXist-db v3.2.0 are available from our [mvn-repo](https://github.com/eXist-db/mvn-repo). Mac users of the [Homebrew](http://brew.sh) package repository will be able to install and upgrade shortly; an announcement will be made on the exist-open mailing list.

