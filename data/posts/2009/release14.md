---
title: "eXist 1.4 final is out!"
date: 2009-11-11
author: "wolf"
tags: []
status: published
migrated-from: AtomicWiki
original-id: "Release14"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/Release14"
---

After another 2 months of hard work or 412 revisions later, we are proud to release eXist 1.4 (codename: Eindhoven) today. Changes since the release candidate include some performance-critical fixes to the collection and nodes caching, as well as improvements in the Lucene index and other extension modules. Based on user feedback, the URL rewriting and MVC framework has been extended to adopt it to more complex real-world scenarios. Examples and documentation have been greatly enhanced.

The release also features experimental support for server-side debugging of XQuery scripts based on the dbgp protocol. The debugger is still a bit limited on the client side (we used emacs and vi since they already implement dbgp), but otherwise usable. We're looking forward to provide a complete implementation in 1.4.1 and would like encourage users to help us testing in the meantime.

For the main features of 1.4, please refer to the previous [release note](/blogs/eXist/Release14rc) or the [press summary](/blogs/eXist/Press/eXist14).

We would like to thank all committers and users who made this possible. In particular, we had lots of people testing the release, checking the documentation or suggesting fixes. Thanks for your contribution!

We highly recommend that users of 1.2 upgrade to 1.4 after they have tested this release. In 1.4, eXist’s XQuery engine has been redesigned to improve the processing of queries against in-memory documents. This has been causing many issues on 1.2.
