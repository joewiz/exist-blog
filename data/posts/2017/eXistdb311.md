---
title: "eXist-db v3.1.1"
date: 2017-03-22
author: "wolf"
tags:
  - "release"
status: published
migrated-from: AtomicWiki
original-id: "eXistdb311"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb311"
---

# Release Notes

## v3.1.1 - March 22, 2017

We are happy to announce the release of eXist-db v3.1.1. This is a bug fix release, which addresses a number of issues and closes two memory leaks. The most important changes are:

- fixed command line parameters for backup/restore and the Java admin client (partially broken in 3.1.0)
- closed memory leak in XQuery map constructor
- closed memory leak preventing memory used for accessing binary resources in XQuery being freed
- added missing dependencies for YAJSW when installing as a System-V service
- corrected fn:doc-available() to return false(), not FODC0005, when the remote resource does not return a document node
- prevented an NPE when an account or a group can't be found by id due to storage corruption or a missing account or group

In addition to eXist-db itself, this release includes updated versions of a number of the bundled applications: Documentation (v0.4.8), Monitoring and Profiling AKA "Monex" (v0.9.7), Shared Resources (v0.4.2). Other applications updated since the last release of eXist-db include Demo Apps (v0.4.0), Public Application Repository (v0.6.0), and XQuery Versioning Module (v1.1.2). The updated versions and their release notes are all available via Dashboard > Package Manager or from the [Public Application Repository](http://demo.exist-db.org/exist/apps/public-repo/index.html).

### Backwards Compatibility

- eXist-db v3.1.1 is binary-compatible with v3.0 and v3.1.0, but not with previous versions (v2.x). Users upgrading from pre-3.0 versions should perform a full backup and restore to migrate their data.
- eXist-db v3.1.1 requires Java 8.

### Downloading This Version

eXist-db v3.1.1 is available for download from the [eXist-db Releases](https://github.com/eXist-db/exist/releases/tag/eXist-3.1.1) page on GitHub. (The old download page on Sourceforge is no longer updated.) Maven artifacts for eXist-db v3.1.1 are available from our [mvn-repo](https://github.com/eXist-db/mvn-repo) repository. For macOS users of the [Homebrew](http://brew.sh) package manager, eXist-db v3.1.1 is already available.