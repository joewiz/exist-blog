---
title: "eXist-db v3.6.0"
date: 2017-11-27
author: admin
tags: [release]
category: release
status: published
migrated-from: AtomicWiki
original-id: eXistdb360
original-url: https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb360
---


# Release Notes

## v3.6.0 - November 27, 2017

eXist-db v3.6.0 has just been released. This is a minor release, which contains several new features and bug fixes.

### Features
* Switched Collation support to use [ICU4j](http://site.icu-project.org).
* Implemented XQuery 3.1 [UCA (Unicode Collation Algorithm)](https://www.w3.org/TR/xpath-functions-31/#uca-collations).
* Implemented `map` type parameters for XQuery F&O 3.1 `fn:serialize`.
* Implemented `declare context item` for XQuery 3.0.
* Implemented XQuery 3.0 Regular Expression's support for non-capturing groups.
* Implemented a type-safe DSL for describing and testing transactional operations upon the database.
* Implemented missing node kind tests in the XQuery parser when using `@` on an `AbbrevForwardStep`.
* Added AspectJ support to the IntelliJ project files (IntelliJ Ultimate only).
* Repaired the dependencies in the NetBeans project files.
* Added support for Travis macOS CI.
* Added support for AppVeyor Windows CI.
* Updated third-party dependencies:
    * Apache Commons Codec 1.11
    * Apache Commons Compress 1.15
    * Apache Commons Lang 3.7
    * Eclipse AspectJ 1.9.0.RC1
    * Eclipse Jetty 9.4.7.v20170914
    * EXPath HTTP Client 20171116
    * Java 8 Functional Utilities 1.11
    * JCTools 2.1.1
    * XML Unit 2.4.0

### Performance Improvements
* Compiled XQuery cache is now multi-threaded; concurrency is now per-source.
* RESTXQ compiled XQuery cache is now multi-threaded; concurrency is now per-query URI.
* STX Templates Cache is now multithreaded.
* XML-RPC Server will now use Streaming and GZip compression if supported by the client; enabled in eXist's Java Admin Client.
* Reduced object creation overhead in the XML-RPC Server.

### Apps
The bundled applications of the Documentation, eXide, and Monex have all been updated to the latest versions.

### Bug fixes
* Fixed compilation for Java 9. eXist-db can now be compiled and run on Java 9.
* Fixed a regression with the XQuery 3.0 Arrow Operator, when it was used in a function, to call a function which is declared later in the XQuery.
* Fixed a regression in the Lucene Range Index where nested content should always be included for an index key, unless configured otherwise.
* Fixed a regression in the EXPath HTTP Client. Previously required you to specify `http-version`, now again defaults to `1.1`.
* Fixed a `NullPointerException` in the EXPath HTTP Client when using Basic Authentication.
* XInclude support now correctly implements fallback if a HTTP resource cannot be accessed.
* Fixes a number of issues where `InputStream`s were not closed, which leaked file handles; particularly an issue on Windows platforms.
* Fixed a database shutdown issue with `SymbolTable` on Windows platforms.
* Ensured that URIs are correctly resolved in the `SourceFactory` on Windows platforms.
* No longer use a custom temp folder, instead use Java's; fixes a bug with Jetty on Windows platforms.
* Fixed an issue where the `EXIST_HOME` path was not constructed correctly under some circumstances on Windows platforms.
* Fixed the return type of `fn:doc` to match the XQuery F&O specification.
* Fixed a concurrency issue in the HTTP `SessionManager`.
* Fixed a concurrency issue in caching Query results in the REST Server.
* Fixed a concurrency issue in caching Query results in the XML-RPC Server.
* Fixed the function description of `util:eval-with-context`.
* Improved error reporting when loading extension modules and EXPath packages.
* `fn:format-number` now returns correct error code: `FODF1310`.
* Fixed decimal formatting in `fn:format-number`.
* Fixed QName equality comparison error code, to correctly return `XPTY0004`.
* `fn:analyze-string` now adheres to XQuery Regular Expression syntax and not the wider Java Regular Expression syntax.
* `fn:doc-available` now only raises FODC0005 if the supplied URI is invalid.
* Fixed Font Resolution when using Apache FOP via XSL-FO extension module.
* Fixed a `StackOverflowException` in the History Trigger.
* Fix to ensure that only signed dependencies end-up in the WAR build.


### Backwards Compatibility

- eXist-db v3.6.0 is backwards binary-compatible as far as v3.0, but not with earlier versions. Users who are upgrading should always consult the [Upgrading Guide](http://exist-db.org/exist/apps/doc/upgrading.xml) in the documentation.


### Downloading This Version

* eXist-db v3.6.0 is available for download from [GitHub](https://github.com/eXist-db/exist/releases/tag/eXist-3.6.0).
* Docker images for are available from EvolvedBinary's [DockerHub](https://hub.docker.com/r/evolvedbinary/exist-db/tags/).
* Maven artifacts are available from our [mvn-repo](https://github.com/eXist-db/mvn-repo).
* Mac users of the [Homebrew](http://brew.sh) package repository may acquire eXist 3.6.0 directly from there.
