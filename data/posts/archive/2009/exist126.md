---
title: "eXist 1.2.6 Maintenance Release"
date: 2009-06-19
author: wolf
tags: []
status: published
migrated-from: AtomicWiki
original-id: eXist126
original-url: https://exist-db.org/exist/apps/wiki/blogs/eXist/eXist126
---


# NOTE: This post was auto-migrated from AtomicWiki and may need manual review.

eXist 1.2.6 is another maintenance release, containing fixes for critical stability issues we found while working on the 1.3 branch. Important changes include: - automatic document defragmentation could have unpredictable results if nodes were updated during a query - Java service wrapper sometimes killed eXist too early, causing corruptions in the db (see []()) - fixed db corruption after crash recovery - query optimizer in some cases failed to analyze called functions, thus causing bad performance - fixed evaluation of positional predicates with a //n abbreviated step (which translates to /desendant-or-self::node()/n) Like all releases in the 1.2.x series, eXist 1.2.6 is not meant to introduce new features (those are reserved for 1.3/1.4). The only new feature in 1.2.6 is support for incremental backups. I will now continue to wrap up 1.3. We still lack documentation and there are a few regressions to fix before 1.3 can be handed out.