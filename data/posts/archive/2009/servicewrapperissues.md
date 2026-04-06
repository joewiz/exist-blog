---
title: "Java Service Wrapper Issues"
date: 2009-05-14
author: wolf
tags: []
status: published
migrated-from: AtomicWiki
original-id: ServiceWrapperIssues
original-url: https://exist-db.org/exist/apps/wiki/blogs/eXist/ServiceWrapperIssues
---


# NOTE: This post was auto-migrated from AtomicWiki and may need manual review.

I recently had some problems with a Windows server running eXist trunk as a service. The service restarted a few times during the day (mainly due to memory issues which have been fixed since then). However, eXist did not get online again after the first restart. What happened? The Java service wrapper has a timeout: when launching a new JVM, it will only wait for a certain time for the newly started process to respond. If it doesn't respond within that timeframe, the wrapper will assume that something went wrong and kills the process. It then starts the next attempt. Now, during the first restart, eXist detected that it wasn't terminated cleanly. It thus triggered a recovery run, which also involved a reindex. This all happened within the service startup method, and since the reindex took longer than 60 seconds, the service wrapper timed out and killed eXist. During the next restart, eXist would again start the recovery - and get killed again! The wrapper never gave it enough time to get up. Even worse, crashing eXist during the recovery phase can cause serious damage to the database files. We have now introduced a callback mechanism which can be used by the service wrapper to communicate with eXist. eXist will periodically send a signal to the wrapper while it's starting up or shutting down. The wrapper will extend its timeouts accordingly. The required changes are available in SVN trunk and have also been ported back to the eXist-stable-1.2 branch (which is the basis of all 1.2.x releases). If you experience corruptions after a service restart, please consider an update. We are also thinking about a 1.2.6 release.