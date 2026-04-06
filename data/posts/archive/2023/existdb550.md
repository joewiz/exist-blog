---
title: "eXist-db 5.5.0"
date: 2023-01-12
author: adam
tags: [release, article]
category: release, article
status: published
migrated-from: AtomicWiki
original-id: eXistdb550
original-url: https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb550
---

# eXist-db 5.5.0 Release Notes

Version 5.5.0 includes critical fixes for defects found in version 5.4.0. It is recommended that all users of eXist-db 5.x.x upgrade to version 5.5.0 or newer.

## Features and Improvements

* request:get-data#0 should support Chunked Transfer Encoding by @adamretter in [#4343](https://github.com/eXist-db/exist/pull/4343)
* Use newer Java 8 JVM memory options for better compatibility with Docker by @adamretter in [#4282](https://github.com/eXist-db/exist/pull/4282)
* Improve performance of JAC Query Dialog by @adamretter in [#4357](https://github.com/eXist-db/exist/pull/4357)
* Improve XSLT errors by @adamretter in [#4373](https://github.com/eXist-db/exist/pull/4373)
* Limit the number of hardware threads to a max of 16 in some tests by @adamretter in [#4370](https://github.com/eXist-db/exist/pull/4370)
* Do not override Bearer Authentication with Basic Authentication by @adamretter in [#4376](https://github.com/eXist-db/exist/pull/4376)
* Fix issues with range, precision, and exponent with fn:xml-to-json by @adamretter in [#4388](https://github.com/eXist-db/exist/pull/4388)
* Improve out-of-scope detection for binary variables by @adamretter in [#4410](https://github.com/eXist-db/exist/pull/4410)
* Report null results instead of throwing NPE by @adamretter in [#4489](https://github.com/eXist-db/exist/pull/4489)
* Capture xs:anyURI error details in XMLDB Module by @adamretter in [#4353](https://github.com/eXist-db/exist/pull/4353)
* Improvements to system:as-user by @adamretter in [#4350](https://github.com/eXist-db/exist/pull/4350)

## Bug Fixes

* Fix regression in util:document-id by @adamretter in [#4271](https://github.com/eXist-db/exist/pull/4271)
* Fix a security privilege escalation issue with XQueryTrigger by @adamretter in [#4275](https://github.com/eXist-db/exist/pull/4275)
* Fix XQuery Trigger chaining by @adamretter in [#4283](https://github.com/eXist-db/exist/pull/4283)
* Allow BigDecimal and BigInteger values to be declared via XML:DB API by @adamretter in [#4419](https://github.com/eXist-db/exist/pull/4419)
* Backport of encoding and file module fixes by @line-o in [#4324](https://github.com/eXist-db/exist/pull/4324)
* Send a valid HTTP Accept Header by @adamretter in [#4299](https://github.com/eXist-db/exist/pull/4299)
* Reinstate all XQuery 3 tests by @adamretter in [#4310](https://github.com/eXist-db/exist/pull/4310)
* Fix XML Catalogue Resolution by @adamretter in [#4329](https://github.com/eXist-db/exist/pull/4329)
* Fix catalog uris when using Windows Paths by @adamretter in [#4339](https://github.com/eXist-db/exist/pull/4339)
* Add missing entity-resolver elements to the Schema for collection.xconf by @adamretter in [#4363](https://github.com/eXist-db/exist/pull/4363)
* override resource type from backup metadata by @reinhapa in [#4380](https://github.com/eXist-db/exist/pull/4380)
* Share common code between RestoreHandler and SystemImportHandler by @adamretter in [#4403](https://github.com/eXist-db/exist/pull/4403)
* Fix additional issues with ResourceType and MediaType during Restore by @adamretter in [#4404](https://github.com/eXist-db/exist/pull/4404)
* Fix the Node Test for document-node(element(name)) by @adamretter in [#4396](https://github.com/eXist-db/exist/pull/4396)
* Update IntelliJ IDEA IDE config for eXist-db 5.5.0-SNAPSHOT by @adamretter in [#4417](https://github.com/eXist-db/exist/pull/4417)
* Fix numerous bugs in numeric operations by @adamretter in [#4436](https://github.com/eXist-db/exist/pull/4436)
* Fix the use of Function Reference from with a Predicate by @adamretter in [#4415](https://github.com/eXist-db/exist/pull/4415)
* Avoid an NPE when disposing Binary Values by @adamretter in [#4463](https://github.com/eXist-db/exist/pull/4463)
* Fix resource leak (and file lock) by @adamretter in [#4524](https://github.com/eXist-db/exist/pull/4524)
* Change URL for two unparsed-text tests by @adamretter in [#4551](https://github.com/eXist-db/exist/pull/4551)
* Fix issues with document-node lookups on various axis by @adamretter in [#4549](https://github.com/eXist-db/exist/pull/4549)
* Fixes an issue with XSuite not being able to run some formulations of XQsuite by @adamretter in [#4590](https://github.com/eXist-db/exist/pull/4590)
* Jetty dtd references must now use https instead of http by @StephanMa in [#4619](https://github.com/eXist-db/exist/pull/4619)

## Updated Dependencies

* Update to Xerces 2.12.2 by @adamretter in [#4307](https://github.com/eXist-db/exist/pull/4307)

**Full Changelog**: [https://github.com/eXist-db/exist/compare/eXist-5.4.1...eXist-5.5.0](https://github.com/eXist-db/exist/compare/eXist-5.4.1...eXist-5.5.0)