---
title: "eXist-db v3.4.0"
date: 2017-07-26
author: "wolf"
tags:
  - "release"
status: published
migrated-from: AtomicWiki
original-id: "eXistdb340"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb340"
---

# Release Notes

## v3.4.0 - July 26, 2017

eXist-db v3.4.0 has just been released. This is a minor release, which introduces one new feature and fixes important issues.

### New Features

* Added function `fn:sort` defined by the XQuery 3.1 function library

### Bug fixes

* Closes several memory leaks which affect nearly all applications making extensive use of library modules or inline functions. As the leaked objects are small on average, the time it takes for the growing memory usage to become manifest depends on average load and complexity of the app (typically a server may run for several weeks until it becomes slow and eventually crashes)
* Variables pointing to binary values were destroyed too early when they were running out of scope
* Running eXist via the system tray launcher on Mac OSX resulted in random crashes of the Java VM. The Mac .dmg distribution of eXist was thus unusable
* Small fix to `IndexListener` interface used by extension indexes: `endElement` should be called with a valid node
* Cleaned up the Cache Module so it is thread-safe. Also added a facility for configuring permissions for cache operations
* Fixed `file:serialize`

### Backwards Compatibility

- eXist-db v3.4.0 is backwards binary-compatible as far as v3.0, but not with earlier versions. Users upgrading from previous versions should perform a full backup and restore to migrate their data.


### Downloading This Version

eXist-db v3.4.0 is available for download from [GitHub](https://github.com/eXist-db/exist/releases/tag/eXist-3.4.0). Maven artifacts for eXist-db v3.4.0 are available from our [mvn-repo](https://github.com/eXist-db/mvn-repo). Mac users of the [Homebrew](http://brew.sh) package repository will be able to install and upgrade shortly; an announcement will be made on the exist-open mailing list.
