---
title: "Warning: Bad Memory Settings in 1.2.2 and 1.2.3"
date: 2008-06-25
author: wolf
tags: []
status: published
migrated-from: AtomicWiki
original-id: WarningBadMemory
original-url: https://exist-db.org/exist/apps/wiki/blogs/eXist/WarningBadMemory
---


# NOTE: This post was auto-migrated from AtomicWiki and may need manual review.

As reported by users, the 1.2.2 and 1.2.3 releases shipped with a bad memory configuration: in the main configuration file (`conf.xml`), the `cacheSize` parameter was set to 256M: &lt;db-connection cacheSize="256M" collectionCache="24M" database="native" files="webapp/WEB-INF/data" pageSize="4096"&gt; However, Java is started with only 128M max. memory, so using 256M for caches will sooner or later result in eXist hitting the wall. The problem here is that the effects of an OutOfMemory error are somehow unpredictable and may lead to unnoticed corruptions in the database. Java doesn't show many warnings before it runs out of memory. All you usually get is a message on stderr. In general, the `cacheSize` parameter in `conf.xml`should never be set to more than 1/3 of the maximum memory available to Java. Please adjust `cacheSize` accordingly or increase Java's max memory (usually set through the `-Xmx` parameter which has to be passed on the java command line - see `bin/functions.d/eXist-settings.sh` or `bin/startup.bat`).