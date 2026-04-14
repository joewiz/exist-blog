---
title: "eXist-db 4.9.0"
date: 2022-01-27
author: "adam"
tags:
  - "release"
  - "article"
status: published
migrated-from: AtomicWiki
original-id: "eXistdb490"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb490"
---

# eXist-db 4.9.0 Release Notes

Version 4.9.0 includes critical fixes for defects found in version 4.8.0. It is recommended that all users of eXist-db 4.x.x upgrade to version 4.9.0 or newer.

**NOTE** We would like to remind users that eXist-db version 4.9.0 includes a version of Log4j2 that is known to have security issues ([CVE-2021-45105](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-45105), [CVE-2021-45046](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-45046), and [CVE-2021-44228](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-44228)), and we would recommend that all users should upgrade to eXist-db 4.10.0 or newer.


## Bug Fixes
* Fixed an issue whereby Renaming or Moving a Collection could corrupt the Collection Hierarchy. Regression since eXist-db 4.7.0 [#4201](https://github.com/eXist-db/exist/pull/4201)
* Fixed an issue whereby it was previously possible to run out of Journal files [#4194](https://github.com/eXist-db/exist/pull/4194)
* Fixed an issue with Collection structures being overwritten during startup [#4188](https://github.com/eXist-db/exist/pull/4188)
* Made the startup more resilient when there are problems with removed Accounts and Groups [#4192](https://github.com/eXist-db/exist/pull/4192)

* Repaired the Ant Build
* Repaired the JUnit Test Suite - all tests passing
* Fixed the CI (Continuous Integration) - Switched from Travis CI to GitHub Actions

## Updated Dependencies
* Apache Ant updated from 1.10.2 to 1.10.12 
* Apache Commons Codec updated from 1.11 to 1.15
* Apache Commons Compress updated from 1.17 to 1.21
* Apache Commons Configuration2 from 2.2 to 2.7
* Apache Commons File Upload updated from 1.3.3 to 1.4
* Apache Commons HTTP Client updated from 4.5.5 to 4.5.13
* Apache Commons HTTP Components updated from 4.4.9 to 4.4.15
* Apache Commons IO from 2.6 to 2.11
* Apache Commons Lang3 updated from 3.7 to 3.12.0
* Apache Commons Net updated from 3.6 to 3.8.0
* Apache FOP updated from 2.3 to 2.6
* Apache Ivy updated from 2.4.0 to 2.5.0
* Apache PDFBox FontBox updated from 2.0.13 to 2.0.22
* Bouncy Castle updated from 1.60 to 1.70
* Caffeine updated from 2.6.2 to 2.9.3
* EasyMock updated from 3.6 to 4.3
* Evolved Binary Java8 Functional Utilities from 1.21 to 1.23.0
* FasterXML UUID Generator updated from 3.1.5 to 3.3.0
* Hamcrest updated from 1.3 to 2.2
* Jansi updated from 1.17.1 to 1.18
* Java JAXB API updated from 2.3.0 to 2.3.1
* JMock updated from 2.4.0 to 2.12.0.jar
* JUnit updated from 4.12 to 4.13.2
* LZ4 for Java updated from 1.5.0 to 1.8.0
* org.json updated from 20140107 to 20211205
* Quartz Scheduler updated from 2.30 to 2.3.2
* Scribe updated from 1.3.5 to 1.3.7
* SLF4j updated from 1.7.25 to 1.7.32
* Smack XMPP updated from 3.1.0 to 3.2.1
* Spy Memcached updated from 2.5 to 2.12.3

