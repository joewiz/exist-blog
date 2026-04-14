---
title: "eXist-db 5.0.0 RC 4"
date: 2018-09-21
author: "admin"
tags:
  - "release"
  - "article"
status: published
migrated-from: AtomicWiki
original-id: "eXistdb500RC4"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb500RC4"
---

## v5.0.0-RC4 - September 21, 2018

The fourth Release Candidate (RC) for eXist-db 5.0.0 has been released.

eXist-db 5.0.0-RC4 builds atop eXist-db [5.0.0-RC3](http://www.exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb500RC3) with a just one new feature, and several small but important bug fixes.

* **NOTE**: A Release Candidate is not recommended for production use. We have tested the release extensively, and we now invite all users to report both their positive and negative experiences with it. As always please make sure you have frequent and correct backups of your database.


### Features

* Added a build target for a .tar.bz2 distribution.

* fn:subsequence was optimised for low memory usage. See [Preventing Large Range Counts from Crashing eXist-db](https://blog.adamretter.org.uk/fixing-existdb-range-oom/).

* Various optimizations for range sequences.

* Deflate compression was added to the Compression extension module.

* Added a runtime configuration option to use MultiLock for Documents as well as Collections.

* Updated to the latest version of MultiLock library.

* Password can now be passed via the Command Line to the Java Admin Client.


### Bug fixes

* Fixed a data-loss issue when reindexing documents which have more than one document-node child.

* Consistency Check now correctly checks all child nodes of the document not just the document element.

* Numerous fixes for the XPath preceding-sibling and following-sibling axes.

* Fixed a problem with incorrect selection on XPath self axis.

* Numerous fixes for addressing nodes which are direct children of the Document Node.

* Fixed a problem where XQuery modules could only be loaded from `xmldb:` style URIs.

* Fixed a +1 bug in XQuery range expressions.

* Fixed JMX Output, eXist-db information was previously missed.

* Fixed an issue with JMX option parsing in Bash start-up scripts.

* Fixed a bug in the Image extension module's crop function.

* Fixed various problems in the SQL extension module:
  * Fixed problems with `null` handling.
  * Resolved several NullPointerException cases.
  * Fixed an issue with empty parameter handling.

* Removed unnecessary buffering with ByteArrayInputStream.

* XML:DB Remote API `#getContentAsDOM()` now returns the correct node type, not just elements.

* DOM API fixes for `#previousSibling()`, `#nextSibling()`, and `#getNode()`.


### Backwards Compatibility
eXist-db 5.0.0-RC4 is backwards compatible up to eXist-db 5.0.0-RC1. For details of backwards compatibility with versions of eXist-db prior to 5.0.0-RC1 please see the [*Backwards Compatibility* details of 5.0.0-RC1](http://www.exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb500RC1).


### Downloading this Version
* eXist-db v5.0.0-RC4 is available for download from [GitHub](https://github.com/eXist-db/exist/releases/tag/eXist-5.0.0-RC4).
* Docker images for are available from eXist-db's [DockerHub](https://hub.docker.com/r/existdb/existdb/tags/).
* Maven artifacts are available from our [mvn-repo](https://github.com/eXist-db/mvn-repo).
* Mac users of the [Homebrew](http://brew.sh) package repository may acquire eXist 5.0.0-RC4 directly from there via. the `exist-db-rc` cask.