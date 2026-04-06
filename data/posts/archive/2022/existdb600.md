---
title: "eXist-db 6.0.0"
date: 2022-01-27
author: adam
tags: [release, article]
category: release, article
status: published
migrated-from: AtomicWiki
original-id: eXistdb600
original-url: https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb600
---

# eXist-db 6.0.0 Release Notes

Apart from two changes, version 6.0.0 is identical to version 5.4.0. The two changes are:

1. It includes an update from Log4j2 version 2.15.0 to version 2.17.1. This Log4j2 update incorporates fixes for security issues [CVE-2021-45105](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-45105), [CVE-2021-45046](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-45046), and [CVE-2021-44228](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-44228). To fix the security issues, Log4j2 removed some log format customisation functionality. eXist-db does not rely on this customisation support in its default configuration, however, if you are using such functionality, you will need to stick with eXist-db 5.4.0 or update your Log4j2 configuration; for more details see: https://logging.apache.org/log4j/2.x/security.html#CVE-2021-44832.

2. It includes an update to the Apache XML-RPC libraries used by eXist-db [#3934](https://github.com/eXist-db/exist/pull/3934). This fixes a known security issues with Apache XML-RPC ([CVE-2019-17570](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2019-17570) and [CVE-2016-5002](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2016-5002)). Unfortunately, this update mandates changing how eXist-db sends the permissions of Documents and Collections over XML-RPC, as such the XML-RPC API in eXist-db 6.0.0 is not considered backwards compatible. If you make use of the XML-RPC API, you may need to use eXist-db 5.4.0 until you can update your applications. [Oyxgen XML Editor](https://www.oxygenxml.com/) is known to use the XML-RPC API as is the [gulp-exist](https://github.com/eXist-db/gulp-exist) tool.

Where possible, we recommend that all users choose to deploy eXist-db 6.0.0 over eXist-db 5.4.0.
