---
title: "eXist-db 4.4.0"
date: 2018-09-21
author: admin
tags: [release, article]
category: release, article
status: published
migrated-from: AtomicWiki
original-id: eXistdb440
original-url: https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb440
---

## v4.4.0 - September 21, 2018

eXist-db v4.4.0 has just been released. This is a minor release, which contains a few new features and several bug fixes.

We recommend that all users of eXist-db 4.x.x should upgrade to eXist-db 4.4.0.


### Features

* Added a build target for a .tar.bz2 distribution.

* fn:subsequence was optimised for low memory usage. See [Preventing Large Range Counts from Crashing eXist-db](https://blog.adamretter.org.uk/fixing-existdb-range-oom/).

* Various optimizations for range sequences.

* Deflate compression was added to the Compression extension module.

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

* Updated the XQuery scheduling functions documentation.

* Fixed a further issue with quotation of Windows paths in the IzPack installer.


### Backwards Compatibility

* eXist-db v4.4.0 is backwards binary-compatible as far as eXist-db v3.0, but not with earlier versions. Users who are upgrading should always consult the [Upgrading Guide](http://exist-db.org/exist/apps/doc/upgrading.xml) in the documentation.

* **NOTE**: The version of Dashboard that was installed with eXist-db 3.6.1 (or earlier) is incompatible with eXist-db 4.0.0 and newer. If you plan to migrate your entire database to eXist-db 4.4.0, you **MUST** take one of the following steps to allow Dashboard to work after the upgrade:

    1. If you have not yet installed eXist-db 4.4.0, open `Dashboard > Package Manager`, and upgrade Dashboard to `0.4.10`, or run this script in eXide or the Java Admin Client: `repo:install-and-deploy("http://exist-db.org/apps dashboard", "http://demo.exist-db.org/exist/apps/public-repo/modules/find.xql")`. Then you may safely install eXist-db 4.4.0 and use Dashboard.

	2. If you install eXist-db 4.4.0 before upgrading Dashboard, run this script in eXide or the Java Admin Client: `repo:install-and-deploy("http://exist-db.org/apps/dashboard", "http://demo.exist-db.org/exist/apps/public-repo/modules/find.xql")`. Then you may use Dashboard.


### Downloading This Version
* eXist-db v4.4.0 is available for download from [GitHub](https://github.com/eXist-db/exist/releases/tag/eXist-4.4.0).
* Docker images are available from EvolvedBinary's [DockerHub](https://hub.docker.com/r/evolvedbinary/exist-db/tags/).
* Maven artifacts are available from our [mvn-repo](https://github.com/eXist-db/mvn-repo).
* Mac users of the [Homebrew](http://brew.sh) package repository may acquire eXist 4.4.0 directly from there.