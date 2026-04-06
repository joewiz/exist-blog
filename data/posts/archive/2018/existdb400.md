---
title: "eXist-db v4.0.0"
date: 2018-02-14
author: admin
tags: [release]
category: release
status: published
migrated-from: AtomicWiki
original-id: eXistdb400
original-url: https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb400
---

# Release Notes

## v4.0.0 - February 14, 2018

eXist-db v4.0.0 has just been released. This is a major release, which contains, API changes, several new features and bug fixes.

### Features
* Added `fn:unparsed-text`, `fn:unparsed-text-lines` and `fn:unparsed-text-available` functions.
* Implemented HTML ASCII Case Insensitive Collation for XPath 3.1.
* Replaced `ASCIIFoldingFilter` with `ICUFoldingFilter` in `NoDiacriticsAnalyzer` for better language search support.
* New User Manager application shipped for the Dashboard.
* Updated Cache Extension Module:
    * Now implements an LRU policy with both TTL and size options.
    * New functions: `cache:names()`, `cache:keys($name)`, and `cache:destroy($name)`.
* Scheduled task option `unschedule-on-exception` is now exposed in `conf.xml`.
* Each thread that eXist creates is now explicitly named for easier identification.
* Bash Scripts now use `/bin/env` to locate bash.
* Updated third-party dependencies:
    * Apache Commons Configuration 2 2.2
    * Apache Commons IO 2.6
    * Caffeine 2.6.1
    * EasyMock 3.5.1
    * Eclipse AspectJ 1.9.0.RC2
    * Eclipse Jetty 9.4.8.v20171121
    * IBM ICU4j 60.2
    * Jackson 2.9.3
    * Java 8 Functional Utilities 1.12
    * Log4J 2.10.0
    * XMLUnit 2.5.1
    * YAJSW 12.11

## Performance Improvements
* Cache Extension Module rewritten to use Caffeine.

### Bug Fixes
* Corrected concurrent access to Document Metadata, previously incorrect due to lazy-loading and incorrect locking.
* DocumentSets now always unlock all locks that they acquired.
* Fixed a number of issues with `xs:base64Binary` and `xs:hexBinary` returned from XQuery execution in various API's.
* Fixed a regression with XQuery Update insert into an empty element.
* Fixed a bug in the EXPath HTTP Client with connection pooling.
* Fixed a bad thread synchronization in JMX.
* Corrected invalid type `empty()` to `empty-sequence()`.
* Fixed overzealous locking in XML:DB Local API copy operations.
* Fix to Namespace handling on in-memory DOM nodes.
* Fixed a `NullPointerException` in `fn:id`.
* Fixed comparison issue with empty sequences.
* Fixed broker leak in Image Extension Module.
* Math Extension Module functions now correctly report their namespace prefix.
* Improved function signatures types:
	* `map` to `map(*)`
	* `array` to `array(*)`
	* `function` to `function(*)`
* Fixed the XQuery Error Codes of several atomic value comparison operators.
* Improved warning and error messages during EXPath Package deployment.
* Many file path related fixes for building and running on Microsoft Windows platforms.
* Removed last Java Endorsed Library paths to support Java 9.
* Updated the Java AppBundler (which is used for staring eXist), to provide better Java 9 support.
* Build labels are now correctly calculated when building from an installed (not-git) product.
* IntelliJ IDEA project files now support correct ApectJ tools.

### Apps
The bundled applications of the Documentation, eXide, and Monex have all been updated to the latest versions. A new UserManager application is also shipped, which replaces the previous in-built UserManager of the Dashboard.

### API Changes
* Legacy XQuery draft syntax `empty()` has been removed. You should now use the spec. compliant syntax `empty-sequence()`.
* The previously `numeric` type was renamed to `xs:numeric`. `numeric` is now marked as legacy.
* The legacy Atom module (`org.exist.atom`) has been removed.
* Sending an invalid XQuery to the RESTServer now correctly returns HTTP 400 Bad Request, instead of HTTP 202 Accepted.
* XMLDB API interfaces have been renamed to be more consistent (e.g. `EXistXQueryService`)
* Locks are now re-acquired by a Transaction rather than ownership transferred.

### Backwards Compatibility

* eXist-db v4.0.0 is backwards binary-compatible as far as v3.0, but not with earlier versions. Users who are upgrading should always consult the [Upgrading Guide](http://exist-db.org/exist/apps/doc/upgrading.xml) in the documentation.

* **NOTE**: The version of Dashboard that was installed with eXist-db 3.6.1 (or earlier) is incompatible with eXist-db 4.0.0. If you plan to migrate your entire database to eXist-db 4.0.0, you **MUST** take one of the following steps to allow Dashboard to work after the upgrade:

    1. If you have not yet installed eXist-db 4.0.0, open `Dashboard > Package Manager`, and upgrade Dashboard to `0.4.10`, or run this script in eXide or the Java Admin Client: `repo:install-and-deploy("http://exist-db.org/apps/dashboard", "http://demo.exist-db.org/exist/apps/public-repo/modules/find.xql")`. Then you may safely install eXist-db 4.0.0 and use Dashboard.
    
    2. If you install eXist-db 4.0.0 before upgrading Dashboard, run this script in eXide or the Java Admin Client: `repo:install-and-deploy("http://exist-db.org/apps/dashboard", "http://demo.exist-db.org/exist/apps/public-repo/modules/find.xql")`. Then you may use Dashboard.

### Downloading This Version
* eXist-db v4.0.0 is available for download from [GitHub](https://github.com/eXist-db/exist/releases/tag/eXist-4.0.0).
* Docker images for are available from EvolvedBinary's [DockerHub](https://hub.docker.com/r/evolvedbinary/exist-db/tags/).
* Maven artifacts are available from our [mvn-repo](https://github.com/eXist-db/mvn-repo).
* Mac users of the [Homebrew](http://brew.sh) package repository may acquire eXist 4.0.0 directly from there.