---
title: "LTS 2.1.5 Released"
date: 2014-05-06
author: admin
tags: [LTSrelease]
category: LTSrelease
status: published
migrated-from: AtomicWiki
original-id: LTS215New
original-url: https://exist-db.org/exist/apps/wiki/blogs/lts/LTS215New
---

eXist LTS 2.1.5 was released today by eXist Solutions GmbH. This bugfix release mainly addresses an issue where a user accounts was not properly reloaded during restore. When restoring from a backup, the internal cache for user accounts was not updated which led to restore failures ("wrong admin password" and other errors).

The release was preponed in favor to the upcoming eXist LTS 2.1.6 release to ensure the stability of our customers production systems. 

As always the eXist LTS 2.1.5 release is via the LTS Customer Portal.