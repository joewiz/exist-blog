---
title: "1.4 Release Candidate"
date: 2009-09-08
author: "adam"
tags: []
status: published
migrated-from: AtomicWiki
original-id: "Release14rc"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/Release14rc"
---

We are happy to announce a release candidate for eXist version 1.4 is now available for [download](http://exist-db.org/download.html). The final release should follow soon after, and will supersede the current 1.2 series as the stable branch.

Among many other things, the 1.4 release features:

- Faster, feature rich [full text indexing](http://exist-db.org/lucene.html). This is based on Apache Lucene which has been transparently integrated into the XQuery engine and works well with other modules in eXist, e.g. match highlighting and KWIC display.

<!-- -->

- Lightweight [URL rewriting and MVC](http://exist-db.org/urlrewrite.html) framework.

<!-- -->

- Support for [XProc](http://demo.exist-db.org/exist/xproc/examples.xml) and easier integration of [XForms](http://demo.exist-db.org/exist/xforms/examples.xml) (via XSLTForms).

<!-- -->

- Basic [document versioning](http://exist-db.org/versioning.html) toolbox.

<!-- -->

- Improved [XML validation and catalog management](http://exist-db.org/validation.html).

<!-- -->

- Documentation - many improvements and additions, including better XQuery function documentation.

However, the most important change of this release is behind the scenes – eXist’s XQuery engine has been redesigned to improve the processing of queries against in-memory documents. This has been the major bottleneck of the 1.2.x series; Experience shows that many applications will benefit from the newly redesigned core. Additionally there have been many small optimizations to the query engine, thus enabling eXist to further optimise its use of indexes or avoid unnecessary steps when evaluating positional predicates.

Please have a look at the [Upgrade Guide](http://exist-db.org/upgrading.html) before installing the new version. N.B. –Several important default settings have changed!
