---
title: "Installer Issues"
date: 2008-06-11
author: "wolf"
tags: []
status: published
migrated-from: AtomicWiki
original-id: "Release123"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/Release123"
---

We still had some issues with the installer in the 1.2.2 release. This was a major problem for some users who redistribute eXist with their own application. Version 1.2.3 has been uploaded to solve those issues.

It also fixes the consistency checker, which was introduced with 1.2.1 and unfortunately triggered a false alarm in some cases.

Updating is not really necessary unless you had problems with the installer or rely on the consistency check service. The 1.2 branch is maintained separately from the development branch. This allows us to release selected bug fixes and improvements much more frequently.
