---
title: "eXist-db 4.10.0"
date: 2022-01-27
author: "adam"
tags:
  - "release"
  - "article"
status: published
migrated-from: AtomicWiki
original-id: "eXistdb4100"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb4100"
---

# eXist-db 4.10.0 Release Notes

Verison 4.10.0 is identical to version 4.9.0, apart from it includes an update from Log4j2 version 2.15.0 to version 2.17.1. This Log4j2 update incorporates fixes for security issues [CVE-2021-45105](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-45105), [CVE-2021-45046](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-45046), and [CVE-2021-44228](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-44228). To fix the security issues, Log4j2 removed some log format customisation functionality. eXist-db does not rely on this customisation support in its default configuration, however, if you are using such functionality, you will need to stick with eXist-db 4.9.0 or update your Log4j2 configuration; for more details see: [https://logging.apache.org/log4j/2.x/security.html#CVE-2021-44832](https://logging.apache.org/log4j/2.x/security.html#CVE-2021-44832).

Where possible, we recommend that all users choose to deploy eXist-db 4.10.0 over eXist-db 4.9.0.

