---
title: "Eclipse build path problems"
date: 2009-04-17
author: "dmitriy"
tags:
  - "faq"
status: published
migrated-from: AtomicWiki
original-id: "Eclipsebuildpath"
original-blog: "eXist/FAQ"
---

**Question: I am in the process of documenting the checkout and build using eclipse. Once the code is checked out and I switch to the Java perspective, I get the missing jar errors.**

Answer: The missing jars are used by extension modules which are not build by default. You can simply ignore those messages as long as you are not using or editing the corresponding extensions.

To enable the extensions, edit extensions/indexes/build.properties. Calling build.sh the next time will download the missing jars.
