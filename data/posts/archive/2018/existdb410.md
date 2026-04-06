---
title: "eXist-db 4.1.0"
date: 2018-04-16
author: wolf
tags: [release, article]
category: release, article
status: published
migrated-from: AtomicWiki
original-id: eXistdb410
original-url: https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb410
---

# Release Notes

## v4.1.0 - April 16, 2018

eXist-db v4.1.0 has just been released. This is a minor release, which contains important bug fixes. Updating to this release is recommended to users experiencing any of the issues below:

### Important Bug Fixes

*   A long standing bug caused 0-byte XML documents to appear in database collections. The bug occurred randomly. The document showed up in the collection but was empty when opened.
*   Wrong nodes being returned as the result of an XQuery predicate using a range index. Serializing the returned sequence would show seemingly random nodes from the same document.
*   Several issues and regressions concerning handling binary resources have been fixed.

### Features

*   XSuite - Proper integration between JUnit, and XQSuite and XML XQuery tests.
*   Add more Travis CI JDKs (including Java 9).
*   Support more locales for month and day names in format-date.
*   Add support for charset encoding from http response.
*   Updates:
    *   Jetty 9.4.9.v20180320
    *   YAJSW 12.12
    *   AspectJ 1.9.0.RC4
    *   cglib 3.2.6
    *   j8fu 1.13
    *   Jackson 2.9.4
    *   jctools 2.1.2
    *   log4j 2.11.0
    *   Commons Compress 1.16.1
    *   Apache HTTP Components 4.5.5

Performance Improvements
------------------------

*   Switch to non-concurrent ByteArrayOutputStream.

### Bug Fixes

*   Fix regression with binary values from files and strings.
*   Fix parsing of QNames in XQuery: The XQuery parser ignored whitespace when parsing a qname, leading to a wrong interpretation of ':' in some contexts, e.g. map constructors.
*   Close input stream in fn:json-doc.
*   Enable previously disabled tests.
*   Fix wildcard lookup in ft:query.
*   Align xml:id handling with saxon and basex.
*   Closing inputstreams and improve ByteArrayOutputStream usage.

### Apps

The bundled applications of eXide, and Monex have all been updated to the latest versions.

### Backwards Compatibility

*   eXist-db v4.1.0 is backwards binary-compatible as far as v3.0, but not with earlier versions. Users who are upgrading should always consult the [Upgrading Guide](http://exist-db.org/exist/apps/doc/upgrading.xml) in the documentation.
*   **NOTE**: The version of Dashboard that was installed with eXist-db 3.6.1 (or earlier) is incompatible with eXist-db 4.0.0 and later. If you plan to migrate your entire database to eXist-db 4.1.0, you **MUST** take one of the following steps to allow Dashboard to work after the upgrade:
    1.  If you have not yet installed eXist-db 4.1.0, open `Dashboard > Package Manager`, and upgrade Dashboard to `0.4.10`, or run this script in eXide or the Java Admin Client: `repo:install-and-deploy("http://exist-db.org/apps/dashboard", "http://demo.exist-db.org/exist/apps/public-repo/modules/find.xql")`. Then you may safely install eXist-db 4.0.0 and use Dashboard.
    2.  If you install eXist-db 4.1.0 before upgrading Dashboard, run this script in eXide or the Java Admin Client: `repo:install-and-deploy("http://exist-db.org/apps/dashboard", "http://demo.exist-db.org/exist/apps/public-repo/modules/find.xql")`. Then you may use Dashboard.

### Downloading This Version

*   eXist-db v4.1.0 is available for download from [Bintray](https://bintray.com/existdb/releases/exist/4.1.0).
*   Docker images for are available from EvolvedBinary's [DockerHub](https://hub.docker.com/r/evolvedbinary/exist-db/tags/).
*   Maven artifacts are available from our [mvn-repo](https://github.com/eXist-db/mvn-repo).
*   Mac users of the [Homebrew](http://brew.sh) package repository may acquire eXist 4.1.0 directly from there.