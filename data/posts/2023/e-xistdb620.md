---
title: "eXist-db 6.2.0"
date: 2023-02-05
author: "adam"
tags:
  - "release"
  - "article"
status: published
migrated-from: AtomicWiki
original-id: "eXistdb620"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb620"
---

# eXist-db 6.2.0 Release Notes

Version 6.2.0 is a very small incremental improvement over 6.1.0 that addresses three late breaking bugs/regressions that were discovered. It is recommended that all users of eXist-db 6.x.x upgrade to version 6.2.0 or newer.

## Bug Fixes

* Ensure that XSLT stylesheets are only compiled once when used from an xsl-pi in the REST Server by @adamretter in [#4708](https://github.com/eXist-db/exist/pull/4708)
* fn:serialize issues by @line-o in [#4703](https://github.com/eXist-db/exist/pull/4703)
* Don't stop startup if an EXPath Package cannot be loaded [#4693](https://github.com/eXist-db/exist/issues/4693)

## Updated Application Dependencies

* Bump ant.version from 1.10.12 to 1.10.13 by @dependabot in [#4711](https://github.com/eXist-db/exist/pull/4711)
* Bump assertj-core from 3.23.1 to 3.24.2 by @dependabot in [#4717](https://github.com/eXist-db/exist/pull/4717)
* Bump java-uuid-generator from 4.0.1 to 4.1.0 by @dependabot in [#4712](https://github.com/eXist-db/exist/pull/4712)
* Bump jline from 3.21.0 to 3.22.0 by @dependabot in [#4721](https://github.com/eXist-db/exist/pull/4721)
* Bump junit.jupiter.version from 5.9.1 to 5.9.2 by @dependabot in [#4687](https://github.com/eXist-db/exist/pull/4687)
* Bump rsyntaxtextarea from 3.3.1 to 3.3.2 by @dependabot in [#4720](https://github.com/eXist-db/exist/pull/4720)
* Bump tika.version from 2.6.0 to 2.7.0 by @dependabot in [#4723](https://github.com/eXist-db/exist/pull/4723)
* Bump xmlresolver.version from 4.6.0 to 4.6.4 by @dependabot in [#4710](https://github.com/eXist-db/exist/pull/4710)

## Updated Build System Dependencies

* Bump dependency-check-maven from 7.4.4 to 8.0.2 by @dependabot in [#4718](https://github.com/eXist-db/exist/pull/4718)
* Bump maven-failsafe-plugin from 3.0.0-M7 to 3.0.0-M8 by @dependabot in [#4688](https://github.com/eXist-db/exist/pull/4688)
* Bump maven-project-info-reports-plugin from 3.4.1 to 3.4.2 by @dependabot in [#4689](https://github.com/eXist-db/exist/pull/4689)

**Full Changelog**: [https://github.com/eXist-db/exist/compare/eXist-6.1.0...eXist-6.2.0](https://github.com/eXist-db/exist/compare/eXist-6.1.0...eXist-6.2.0)

## Backwards Compatibility

eXist-db 6.2.0 is backwards binary compatible with previous 6.x.x versions, which should make upgrading simple with no changes required to XQuery or XSLT application code. For those users migrating from 4.x.x or 5.x.x versions to 6.x.x a full backup and restore of the database will be required and possibly some small changes to XQuery and XSLT application code. Please review previous releases' notes for detailed information.