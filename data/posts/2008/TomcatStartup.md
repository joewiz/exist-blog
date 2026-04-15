---
title: "eXist-db does not start in Apache Tomcat"
date: 2008-08-22
author: "Wolfgang Meier"
tags:
  - "howto"
status: published
migrated-from: AtomicWiki
original-id: "TomcatStartup"
original-blog: "HowTo"
original-url: "https://exist-db.org/exist/apps/wiki/HowTo/TomcatStartup"
---

The war files are tested and should work. Be sure that tomcat is not setup with the "SecurityManager" enabled (we should work this out) and that (for older versions of tomcat) all relevant XML jar files (xerces, resolver, xalan) have been installed in the 'endorsed' directory.

For more information check our documentation.