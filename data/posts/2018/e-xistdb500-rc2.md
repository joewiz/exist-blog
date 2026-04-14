---
title: "eXist-db 5.0.0 RC 2"
date: 2018-07-25
author: "wolf"
tags:
  - "release"
  - "article"
status: published
migrated-from: AtomicWiki
original-id: "eXistdb500RC2"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb500RC2"
---

## v5.0.0-RC2 - July 25, 2018

The second Release Candidate (RC) for eXist-db 5.0.0 has been released.

eXist-db 5.0.0-RC2 builds atop eXist-db [5.0.0-RC1](http://www.exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb500RC1) with a few new features, important bug fixes, and some small API changes.

* **NOTE**: A Release Candidate is not recommended for production use. We have tested the release extensively, and we now invite all users to report both their positive and negative experiences with it. As always please make sure you have frequent and correct backups of your database.


### Features

	* Implemented basic support for "available collections" in the XQuery dynamic context.

	* Implemented basic support for "available documents" in the XQuery dynamic context.

	* Implemented basic support for "available text resources" in the XQuery dynamic context.

	* Implemented support for the collation used in the XQTS (XQuery Test Suite) 3.1.

    * Incorporated from 4.3.0:
        * Upgraded to Apache Xerces 2.12.0. eXist-db now includes XML Schema 1.1 support.

        * Improved the Remote XML:DB API "networking error" messages to be more descriptive.

        * Test errors are now summarised in XQSuite XML output.


### Bug fixes

	* Fixed a locking issue in the XML:DB Local API when storing XML documents.

	* Fixed an NPE which manifested when storing binary documents when `preserve-on-copy` was enabled.

    * Incorporated from 4.3.1:
        * Fixed a regression introduced in eXist-db 4.3.0, where the type conversion of non-empty XDM Sequences was incorrectly returning an empty sequence. This could lead to insufficient results being returned by an XQuery.

        * Fixed another problem with uploading zero length binary files via. the XML:DB Remote API.

        * Fixed a number of issues with the LDAP Security Realm:
            1. Ensure the authenticated LDAP context is reused.
            2. Always close and dispose of any LDAP context that we create.
            3. Fixed encoding of CN and DN names during LDAP searches.

        * Fixed an issue where the XQuery function `file:serialize` could use the incorrect character encoding depending on which platform eXist-db was being executed on.

        * Fixed a comparison problem with node equality in the DOM API exposed via. the XML:DB Local API.

        * Fixed a `java.nio.file.Path` issue when loading eXist-db's `conf.xml` file from inside a classpath Jar file.

        * Removed unnecessary error level logging of the XQuery `fn:error` function.

        * Fixed an issue with the error message for restoring permissions; Now the entire resource URI is shown.

        * Fixed an initialise/reset issue with Internal Module XQuery variables. This fixed a regression introduced in eXist-db 3.5.0.

        * Fixed a JavaEE dependency runtime issue with Java 11.

        * Downloading of XAR files during the eXist-db build process is now more descriptive.

	* Incorporated from 4.3.0:
        * Fixed an issue where in-memory documents used in XQuery Update insert expressions caused an NPE (NullPointerException).

        * Fixed an issue where XQuery Error Codes were not correctly reported under some circumstances.

        * Fixed an issue with restoring binary files of zero bytes via the XML-RPC and XML:DB Remote API.

        * Fixed a signing issue with running eXist-db from the installer under Java 10.

        * Fixed an issue when constructing in-memory documents with namespaces via SAX parsers.

        * Fixed an issue with namespaces when parsing external documents to in-memory documents.

        * Fixed an issue with namespaces when merging in-memory documents.

        * Fixed a NPE when calling `map:get` for a non-existent key/value map pair.

        * Fixed a NPE in `fn:data`.

        * Fixes a NPE when converting empty sequences.

	* Incorporated from 4.2.1:
        * Fixed an NPE with XQuery Update insert preceding with attributes. Closes [#1761](https://github.com/eXist-db/exist/issues/1761) and [#1939](https://github.com/eXist-db/exist/issues/1939).

        * Only attributes which are considered boolean in HTML5 have their values omitted. Closes [#777](https://github.com/eXist-db/exist/issues/777). Thanks to [Bert Willems](https://github.com/devatwork) from [FontoXML](https://fontoxml.com/) for this fix.

        * Fixed an issue with the XQuery function `inspect:module-functions`, which was previously throwing a NPE. Closes [#1927](https://github.com/eXist-db/exist/issues/1927).

        * Fixed an issue with restoring Compressed (Zip) database backups. Closes [#1913](https://github.com/eXist-db/exist/issues/1913).


### API Changes
    * Users who have XQuery Modules written in Java which implement `org.exist.xquery.InternalModule` should no longer call `InternalModule#declareVariable` from their class constructor, instead they should place those calls in `InternalModule#prepare(XQueryContext)`.

### Backwards Compatibility
Apart from the small API changes described above, eXist-db 5.0.0-RC2 is backwards compatible with eXist-db 5.0.0-RC1. For details of backwards compatibility with versions of eXist-db prior to 5.0.0-RC1 please see the [*Backwards Compatibility* details of 5.0.0-RC1](http://www.exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb500RC1).


### Downloading this Version
* eXist-db v5.0.0-RC2 is available for download from [GitHub](https://github.com/eXist-db/exist/releases/tag/eXist-5.0.0-RC2).
* Docker images for are available from EvolvedBinary's [DockerHub](https://hub.docker.com/r/evolvedbinary/exist-db/tags/).
* Maven artifacts are available from our [mvn-repo](https://github.com/eXist-db/mvn-repo).
* Mac users of the [Homebrew](http://brew.sh) package repository may acquire eXist 5.0.0-RC2 directly from there via. the `exist-db-rc` cask.