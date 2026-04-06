---
title: "eXist-db 4.11.0"
date: 2023-01-11
author: adam
tags: [release, article]
category: release, article
status: published
migrated-from: AtomicWiki
original-id: eXistdb4110
original-url: https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb4110
---

# eXist-db 4.11.0 Release Notes

Version 4.11.0 includes critical fixes for defects found in version 4.10.0. It is recommended that all users of eXist-db 4.x.x upgrade to version 4.11.0 or newer.

## Features and Improvements

* request:get-data#0 should support Chunked Transfer Encoding by @adamretter in [#4342](https://github.com/eXist-db/exist/pull/4342)
* Improve performance of JAC Query Dialog by @adamretter in [#4358](https://github.com/eXist-db/exist/pull/4358)
* Improve XSLT errors by @adamretter in [#4374](https://github.com/eXist-db/exist/pull/4374)
* Allow BigDecimal and BigInteger values to be declared via XML:DB API by @adamretter in [#4420](https://github.com/eXist-db/exist/pull/4420)
* Improve out-of-scope detection for binary variables by @adamretter in [#4408](https://github.com/eXist-db/exist/pull/4408)
* Report null results instead of throwing NPE by @adamretter in [#4490](https://github.com/eXist-db/exist/pull/4490)
* Fail the build if the .xar.zip file that was downloaded was invalid by @adamretter in [#4465](https://github.com/eXist-db/exist/pull/4465)
* Change URL for two unparsed-text tests by @adamretter in [#4552](https://github.com/eXist-db/exist/pull/4552)
* Prevent OutOfMemory on JDK 17 when loading EXPath Modules by @ohumbel in [#4617](https://github.com/eXist-db/exist/pull/4617)
* Add missing entity-resolver elements to the Schema for collection.xconf by @adamretter in [#4364](https://github.com/eXist-db/exist/pull/4364)
* Limit the number of hardware threads to a max of 16 in some tests by @adamretter in [#4371](https://github.com/eXist-db/exist/pull/4371)
* Do not override Bearer Authentication with Basic Authentication by @adamretter in [#4377](https://github.com/eXist-db/exist/pull/4377)
* Fix the Node Test for document-node(element(name)) by @adamretter in [#4397](https://github.com/eXist-db/exist/pull/4397)
* Fix numerous bugs in numeric operations by @adamretter in [#4437](https://github.com/eXist-db/exist/pull/4437)
* Fix the use of Function Reference from with a Predicate by @adamretter in [#4416](https://github.com/eXist-db/exist/pull/4416)
* Ensure that spaces in Windows paths for startup.sh and server.sh are correctly quoted by @adamretter in [#4460](https://github.com/eXist-db/exist/pull/4460)
* Avoid an NPE when disposing Binary Values by @adamretter in [#4464](https://github.com/eXist-db/exist/pull/4464)
* Import the ErrorCodes class by @mcmeeking in [#4494](https://github.com/eXist-db/exist/pull/4494)
* fix resource leak (and file lock) by @adamretter in [#4525](https://github.com/eXist-db/exist/pull/4525)
* Fix issues with document-node lookups on various axis by @adamretter in [#4550](https://github.com/eXist-db/exist/pull/4550)
* Jetty dtd references must now use https instead of http by @StephanMa in [#4616](https://github.com/eXist-db/exist/pull/4616)

## Bug Fixes

* Fix regression in util:document-id by @adamretter in [#4272](https://github.com/eXist-db/exist/pull/4272)
* Fix a security privilege escalation issue with XQueryTrigger by @adamretter in [#4276](https://github.com/eXist-db/exist/pull/4276)
* Fix XQuery Trigger chaining by @adamretter in [#4284](https://github.com/eXist-db/exist/pull/4284)
* Send a valid HTTP Accept Header by @adamretter in [#4300](https://github.com/eXist-db/exist/pull/4300)
* Fix XML Catalogue Resolution by @adamretter in [#4320](https://github.com/eXist-db/exist/pull/4320)
* Reinstate code for a historical Jetty bugfix by @adamretter in [#4344](https://github.com/eXist-db/exist/pull/4344)
* Fix catalog uris when using Windows Paths by @adamretter in [#4340](https://github.com/eXist-db/exist/pull/4340)
* Capture xs:anyURI error details in XMLDB Module by @adamretter in [#4354](https://github.com/eXist-db/exist/pull/4354)

## Updated Dependencies

* Update from Xerces 2.11.0 to 2.12.2 by @adamretter in [#4308](https://github.com/eXist-db/exist/pull/4308)
* Update Jing from version 20151127 to 20181222 by @adamretter in [#4323](https://github.com/eXist-db/exist/pull/4323)
* Update EXPath HTTP Client from 1.1.0 to 1.1.4 by @adamretter in [#4491](https://github.com/eXist-db/exist/pull/4491)

## New Contributors

* @mcmeeking made their first contribution in [#4494](https://github.com/eXist-db/exist/pull/4494)

**Full Changelog**: [https://github.com/eXist-db/exist/compare/eXist-4.10.0...eXist-4.11.0](https://github.com/eXist-db/exist/compare/eXist-4.10.0...eXist-4.11.0)