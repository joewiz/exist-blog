---
title: "TEI Publisher v2.2.0"
date: 2017-08-09
author: wolf
tags: [teipublisher]
category: teipublisher
status: published
migrated-from: AtomicWiki
original-id: teipublisher220
original-url: https://exist-db.org/exist/apps/wiki/blogs/eXist/teipublisher220
---

<div class="row">
<div class="col-md-3"><img src="/exist/apps/blog/resources/images/archive/mobile.png"/></div>
<div class="col-md-9">
We're pleased to announce that the eXist-based [TEI Publisher](http://teipublisher.com) has been released in version 2.2.0. Besides numerous fixes, the most notable change is an **improved responsive design**. Browsing and navigation should now work flawlessly on mobile devices. Other changes:

* Drop /works prefix from document paths to simplify URLs
* Renditions defined in tei header were no longer applied
* Fix image resolving for generated apps
* Allow documents to be deleted via UI
* Include direct link to uploaded document

## Important note

This version also requires an update to the library package `tei-publisher-lib`, which is not backwards compatible with older releases. If you generated an app, it may throw an error after the update.

To fix this, run `.../your-app/modules/lib/regenerate.xql` once from within the browser or eXide.

## Installation

TEI Publisher is available via eXist's package manager in the dashboard. It requires at least eXist 3.1.0.
</div>
</div>