---
title: "eXist-db v3.3.0"
date: 2017-07-02
author: admin
tags: [release]
category: release
status: published
migrated-from: AtomicWiki
original-id: eXistdb330
original-url: https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb330
---

# Release Notes

## v3.3.0 - July 2, 2017

We are happy to announce the release of eXist-db v3.3.0. This is a minor release, which introduces a few small features and addresses a number of issues.


### New Features
- Adaptive serialization mode as defined by XQuery 3.1.
- A DSL which simplifies the definition of functions, function signatures and their parameters for building extension functions.
- An extension mechanism for extension modules to provide valid XPath/XQuery error codes.
- An eXist-db TestKit (`exist-testkit.jar`) which can be used by other projects (e.g. extension module) to execute tests against eXist-db.
- Added `ExistOutputKeys.JSON_IGNORE_WHITESPACE_TEXT_NODES` to discard white-space text nodes when serializing XML/XDM to JSON.


### Bug Fixes
- Fixed the XQuery lookup operator `?` to return the correct result with regards to empty values.
- WebDAV now uses the default configuration for serializing XML.
- Fixed a regression in the `xmldb:restore` Ant task.
- `xs:base64Binary` and `xs:hexBinary` previously now set the correct `srcOffset` in the underlying stream when calling `CachingFilterInputStream#skip`.
- `fn:replace` arguments not now correctly cleared when dynamically called.
- Fixed Lucene `inline` elements in case of not yet applied white-space.
- Improved the AppBundler for the MacOS .app package.
  - Now requires Java 8.
  - Renamed the running process from "JavaAppLauncher" to "eXist-JavaAppLauncher" to make things clearer.


### Clean Up and Refactoring
- Update to the Java Admin Client to use the latest version of RSyntaxArea (2.6.1).
- Update Ant from 1.9.7 to 1.10.1.
- ... and many more 

### Backwards Compatibility

- eXist-db v3.3.0 is backwards binary-compatible as far as v3.0, but not with earlier versions. Users upgrading from previous versions should perform a full backup and restore to migrate their data.


### Downloading This Version

eXist-db v3.3.0 is available for download from [GitHub](https://github.com/eXist-db/exist/releases/tag/eXist-3.3.0). Maven artifacts for eXist-db v3.3.0 are available from our [mvn-repo](https://github.com/eXist-db/mvn-repo). Mac users of the [Homebrew](http://brew.sh) package repository will be able to install and upgrade shortly; an announcement will be made on the exist-open mailing list.