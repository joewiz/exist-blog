---
title: "eXist-db 4.2.0"
date: 2018-06-06
author: "wolf"
tags:
  - "release"
  - "article"
status: published
migrated-from: AtomicWiki
original-id: "eXistdb420"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb420"
---

# Release Notes

## v4.2.0 - June 6, 2018

eXist-db v4.2.0 has just been released. This is a minor release, which contains an important security fix, as well as several new features and bug fixes.

### Security Fixes
* Added avoidance for Zip Slip / Zip Exit attacks.
    * **NOTE**: Developers should take care when writing their own `$entry-data` functions for [`compression:unzip`]({docs}/functions/compression/unzip) or [`compression:untar`]({docs}/functions/compression/untar) if they are writing the file entries to persistent storage using the name of the entry from the archive; Consideration should be given to employing further exit attack protections of their own.


### Features
* XQuery [`compression:unzip`]({docs}/functions/compression/unzip) and [`compression:untar`]({docs}/functions/compression/untar) functions have received some lower-arity signatures which should simplify use. Also some helper functions have been added: [`compression:no-filter`]({docs}/functions/compression/no-filter), `compression:db-store-*`, and `compression:fs-store-*`.
* The XQuery [`util:eval-with-context`]({docs}/functions/util/eval-with-context) function now allows a timeout to be set.
* XQSuite gains the annotation `%test:assumeInternetAccess` for ensuring Internet Access is 
* XML-RPC Server character set is now configurable, defaults to UTF-8.
* XQueryURLRewrite challenge is now configurable, defaults to always challenging for basic authentication.
* Building YAJSW no longer requires `JAVA_HOME` if `java` is available on the system `PATH`.
* `ClassLoaderSource` now tracks source file for easy referencing.
* Display the specific JVM version details when building eXist-db.
* Updated third-party dependencies:
    * Apache Commons Configuration 1.17
    * Java 8 Functional Utilities 1.16
    * FasterXML Jackson 2.9.5
    * Jargo 0.4.14
    * XMLUnit 2.6.0
    * Eclipse Jetty 9.4.10.v20180503
    * Eclipse AspectJ 1.9.1


## Performance Improvements
* Minor performance improvements when streaming binary files from the database.
* Replaced many uses of Reflection with use of Constructor lambda functions and Method Handles.
* Broker construction functions are now cached.
* In the XML:DB Remote API small transfers will not be compressed, which saves both time and space (due to compression overhead).
* XML:DB Remote API no longer allocates full-chunks in memory if they are not required.


### Bug Fixes
* Fixed a memory leak which manifests when making heavy use of higher-order-functions in XQuery.
* Fixed a problem with serialization where empty namespace declarations could be lost. This applies to the XML:DB, XML-RPC and WebDAV interfaces.
* SAX Serialization now handles lexical CDATA sections and DTD's.
* Fixed a potential deadlock when validating XML documents against various types of Schema.
* EXPath HTTP Client now correctly adheres to the character set of the server's response.
* Reduced severity of log messages in the Temporary File Manager.
* Memory Mapping of temporary files is now handled correctly on Microsoft Windows.
* One eXist-db instance can no longer accidentally delete the temporary files of another instance (which may be in use).
* Fixed concurrent use issues with the Index Manager.
* Index configuration changes now cause the Index Controller to be reloaded.
* [`fn:format-date`]({docs}/functions/fn/format-date) previously calculated the name of the day of the week incorrectly (off by one e.g. Monday -> Tuesday).
* [`file:mkdirs`]({docs}/functions/file/mkdirs) no longer incorrectly raises an error if the directory already exists.
* Fixed a `NullPointerException` when uploading large documents via the XML-RPC and XML:DB Remote APIs.
* Handling of Zip entry filenames are now compatible with Java 10.
* Fixed the behaviour of the XMLUnit functions.
* XQSuite now correctly displays results when an error is expected.
* XQSuite now shows the correct messages for `%test:assertTrue` and `%test:assertFalse`.
* XSuite test resources are now correctly loaded from the classpath.


### Backwards Compatibility

* eXist-db v4.2.0 is backwards binary-compatible as far as v3.0, but not with earlier versions. Users who are upgrading should always consult the [Upgrading Guide](http://exist-db.org/exist/apps/doc/upgrading.xml) in the documentation.

* **NOTE**: The version of Dashboard that was installed with eXist-db 3.6.1 (or earlier) is incompatible with eXist-db 4.0.0 and newer. If you plan to migrate your entire database to eXist-db 4.2.0, you **MUST** take one of the following steps to allow Dashboard to work after the upgrade:

    1. If you have not yet installed eXist-db 4.2.0, open `Dashboard > Package Manager`, and upgrade Dashboard to `0.4.10`, or run this script in eXide or the Java Admin Client: `repo:install-and-deploy("http://exist-db.org/apps/dashboard", "http://demo.exist-db.org/exist/apps/public-repo/modules/find.xql")`. Then you may safely install eXist-db 4.2.0 and use Dashboard.
    
    2. If you install eXist-db 4.2.0 before upgrading Dashboard, run this script in eXide or the Java Admin Client: `repo:install-and-deploy("http://exist-db.org/apps/dashboard", "http://demo.exist-db.org/exist/apps/public-repo/modules/find.xql")`. Then you may use Dashboard.


### Downloading This Version
* eXist-db v4.2.0 is available for download from [GitHub](https://github.com/eXist-db/exist/releases/tag/eXist-4.2.0).
* Docker images for are available from EvolvedBinary's [DockerHub](https://hub.docker.com/r/evolvedbinary/exist-db/tags/).
* Maven artifacts are available from our [mvn-repo](https://github.com/eXist-db/mvn-repo).
* Mac users of the [Homebrew](http://brew.sh) package repository may acquire eXist 4.2.0 directly from there.
