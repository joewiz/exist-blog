---
title: "eXist-db 5.4.0"
date: 2022-01-27
author: "adam"
tags:
  - "release"
  - "article"
status: published
migrated-from: AtomicWiki
original-id: "eXistdb540"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb540"
---

# eXist-db 5.4.0 Release Notes

Version 5.4.0 includes critical fixes for defects found in version 5.3.1. It is recommended that all users of eXist-db 5.x.x upgrade to version 5.4.0 or newer.

**NOTE** We would like to remind users that eXist-db version 5.4.0 includes a version of Log4j2 that is known to have security issues ([CVE-2021-45105](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-45105), [CVE-2021-45046](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-45046), and [CVE-2021-44228](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-44228)), and we would recommend that all users should upgrade to eXist-db 6.0.0 or newer.

## Features and Improvements
* The macOS DMG file release is now notarized with Apple [#4169](https://github.com/eXist-db/exist/pull/4169) [#4200](https://github.com/eXist-db/exist/pull/4200)
* Implemented eXist-db specifix seialization options for use with the XQuery function `fn:serialize`; includes: `exist:add-exist-id`, `exist:expand-xincludes`, `exist:highlight-matches`, `exist:jsonp`, `exist:json-ignore-whitespace-text-nodes`, and `exist:process-xsl-pi` [#3990](https://github.com/eXist-db/exist/pull/3990)
* Implemented XQuery 3.1 function `map:merge#2` for `use-first`, `use-last`, and `use-any` 
* Added additional options to the XQuery function `file:sync`; includes: `after`, `exclude`, and `prune` [#4081](https://github.com/eXist-db/exist/pull/4081)
* Added two additional parameter types for use when specifying a custom analyzer: `java.lang.String[]` and `char[]` [#4082](https://github.com/eXist-db/exist/pull/4082)
* Introduced a new and simpler Store Document API [#4157](https://github.com/eXist-db/exist/pull/4157)
* Simplified storage of predicates for XPath steps [#3975](https://github.com/eXist-db/exist/pull/3975)
* Optimised retrieving the first child of an in-memory document [#4013](https://github.com/eXist-db/exist/pull/4013)
* Improved RenderX compatibility with the `xslfo:render` function [#4171](https://github.com/eXist-db/exist/pull/4171)
* Updated the eXist-db Docker Image to use the latest OpenJDK 8 version [#4178](https://github.com/eXist-db/exist/pull/4178)
* Switched from Java to Jakarta JAXB
* XQuery Mail Module now uses latest Jakarta Mail [#3994](https://github.com/eXist-db/exist/pull/3994)
* Improved instructions for recovering the database in `RECOVERY.md` [#4060](https://github.com/eXist-db/exist/pull/4060)
* Improved Backup/Restore CLI options descriptions [#4070](https://github.com/eXist-db/exist/pull/4070)
* Added support for JUnit 5 [#3322](https://github.com/eXist-db/exist/pull/3322)
* Improved how XSuite starts and stops the database [#3985](https://github.com/eXist-db/exist/pull/3988)
* Updated the HomeBrew release instructions [#4141](https://github.com/eXist-db/exist/pull/4141)


## Bug Fixes
* Fix NPE in Function Calls that were defferred due to being forward references [#4204](https://github.com/eXist-db/exist/pull/4204)
* Ensured that XQuery variables are analyzed before evaluated when called from a module [#4120](https://github.com/eXist-db/exist/pull/4120)
* Fixed an issue whereby it was previously possible to run out of Journal files [#4193](https://github.com/eXist-db/exist/pull/4193)
* Fix issues with XQuery Map Immutability [#4000](https://github.com/eXist-db/exist/pull/4000)
* Fixed construction of in-memory DOM attributes [#4013](https://github.com/eXist-db/exist/pull/4013)
* Fixed an issue so that all nodes of an in-memory DOM document can be retrieved (instead of just the document element) [#4013](https://github.com/eXist-db/exist/pull/4013)
* Fixed a Writer handle leak in the REST Server [#4034](https://github.com/eXist-db/exist/pull/4034)
* Fixed a File Handle leak in the Lucene Index [#4065](https://github.com/eXist-db/exist/pull/4065)
* Fixed a File Handle leak in the EXPath Package Auto Deployment Startup Trigger [#4071](https://github.com/eXist-db/exist/pull/4071)
* Fixed an issue with following/preceding axes after predicate on an abbreviated step [#4108](https://github.com/eXist-db/exist/pull/4108)
* Fixed a number of SMTP bugs in the XQuery Mail module [#4159](https://github.com/eXist-db/exist/pull/4159)
* Fixed several issues around XML Reader pooling and reuse [#4021](https://github.com/eXist-db/exist/pull/4021) [#4052]https://github.com/eXist-db/exist/pull/4052)
* Fixed issues with XSuite test descriptions [#3985](https://github.com/eXist-db/exist/pull/3988)
* Serveral fixes to Unary Lookups [#3966](https://github.com/eXist-db/exist/pull/3966)
* Allow Empty Enclosed Expressions in XQuery [#4089](https://github.com/eXist-db/exist/pull/4089)
* Corrected the XQuery function `util:expand` so that it correctly handles Documents and Attributes [#4172](https://github.com/eXist-db/exist/pull/4172)
* Corrected the XQuery function `fn:generate-id` to provide unique IDs for unique Nodes [#4167](https://github.com/eXist-db/exist/pull/4167)
* DejaVu Fonts were updated in the Docker Image [#4028](https://github.com/eXist-db/exist/pull/4028)
* Fixed an impossible type conversion in NativeValueIndex that generated noisy log messages [#4175](https://github.com/eXist-db/exist/pull/4175)

## Updated Dependencies
* Apache Ant updated from 1.10.10 to 1.10.12
* Apache Commons Compress updated from 1.20 to 1.21
* Apache Commons IO updated from 2.10.0 to 2.11.0
* Apache HTTP Components updated from 4.4.14 to 4.4.15
* Apache Tika updated from 1.26 to 2.2.1
* Apache XML Graphics updated from 2.6 to 2.7
* Bouncy Castle updated from 1.69 to 1.70
* Caffeine updated from 2.9.1 to 2.9.3
* Eclipse AspectJ updated from 1.9.4 to 1.9.8-M1
* Eclipse Jetty updated from 9.4.42.v20210604 to 9.4.44.v20210927
* FasterXML Jackson updated from 2.12.3 to 2.13.1
* FastUtil updated from 8.5.4 to 8.5.6
* Jakarta Activation updated from 2.0.0 to 2.0.1
* Jakarta Mail updated from Java Mail 1.6.5 to Jakarta Mail 2.0.1
* Jansi updated from 2.3.3 to 2.4.0
* Java JAXB Runtime updated from 3.0.1 to 3.0.2
* jline updated from 3.20.0 to 3.21.0
* JUnit 5 5.8.2 added
* RSyntaxTextArea updated from 3.1.3 to 3.1.6
* Saxon-HE updated from 9.9.1-7 to 9.9.1-8
* SLF4j updated from 1.7.30 to 1.7.33
* XMLUnit updated from 2.8.2 to 2.8.4