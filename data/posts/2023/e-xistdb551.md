---
title: "eXist-db 5.5.1"
date: 2023-01-12
author: "adam"
tags:
  - "release"
  - "article"
status: published
migrated-from: AtomicWiki
original-id: "eXistdb551"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb551"
---

# eXist-db 5.5.1 Release Notes

Version 5.5.1 includes critical fixes for defects found in version 5.4.0. It is recommended that all users of eXist-db 5.x.x upgrade to version 5.5.0 or newer. Version 5.5.1 is a re-release of eXist-db 5.5.0, as a [small issue](https://github.com/eXist-db/public-repo/issues/84) led to the incorrect versions of accompaying EXPath Packages being shipped with the eXist-db 5.5.0 release.

## Bug Fixes

* Ensure correct eXist-db Dashboard EXPath application version (2.0.9) is packaged in the release.
* Ensure correct eXist-db Documentation EXPath application version (5.4.0) is packaged in the release.
* Ensure correct eXist-db Function Documentation EXPath application version (1.2.0) is packaged in the release.
* Ensure correct FunctX EXPath application version (1.0.1) is packaged in the release.

## Updated Dependencies

* Updated eXist-db eXide EXPath application from version 3.3.0 to 3.5.0
* Updated eXist-db Monex EXPath application from version 3.0.4 to 3.0.5
* Updated eXist-db Package Service EXPath library from version 1.3.13 to 1.3.14
* Updated eXist-db Semver.xq EXPath library from version 2.3.0 to 3.3.0
* Updated eXist-db Templating EXPathlibrary from version 1.0.2 to 1.1.0

**Full Changelog**: [https://github.com/eXist-db/exist/compare/eXist-5.5.0...eXist-5.5.1](https://github.com/eXist-db/exist/compare/eXist-5.5.0...eXist-5.5.1)