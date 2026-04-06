---
title: "eXist-db 6.4.0"
date: 2025-05-06
author: juri
tags: [release, article]
category: release, article
status: published
migrated-from: AtomicWiki
original-id: eXistdb640
original-url: https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb640
---

# Release Notes

Version 6.4.0 is a small feature release that addresses three breaking regressions that were discovered in 6.3.0. 
It is recommended that all users of eXist-db 6.0.0-6.3.0 upgrade to version 6.4.0.

**Important:** The signing keys to prove the integrity of the installers have changed:

- The DMG is signed by `eXist Solutions GmbH (TK5UZLQZR2)`
- The izPack jar installer is signed by `CN=eXist Solutions GmbH, O=eXist Solutions GmbH, L=Lenzkirch, ST=Baden-Wuerttemberg, C=DE`

## Features

* Add new function `system:get-main-module-load-path#0` by @line-o [#5732](https://github.com/eXist-db/exist/pull/5732)
* Multi architecture Docker images (x86_64 and arm64) by @duncdrum [#5729](https://github.com/eXist-db/exist/pull/5729)
* Universal binary DMGs [#5729](https://github.com/eXist-db/exist/pull/5729)

## Bug Fixes

* Reapply "Merge pull request #4541 from eXistSolutions/field-perf-revised" [#4541](https://github.com/eXist-db/exist/pull/4541)
* Update test SSL certificate by @line-o [#4541](https://github.com/eXist-db/exist/pull/4541)
* Repair JNLP interface, use correct BC library by @dizzz [#5554](https://github.com/eXist-db/exist/pull/5554)
* Allow module imports in one-off xqueries by @line-o fixes [#5525](https://github.com/eXist-db/exist/issues/5525) and [#5530](https://github.com/eXist-db/exist/issues/5530)
* Registered import-uris have precedence @line-o fixes import of XSL stylesheets registerd in expath package repository
* Filter properties included in izPack installer [#5723](https://github.com/eXist-db/exist/pull/5723)
* Fix NPE in nested anonymous functions by @line-o [#5717](https://github.com/eXist-db/exist/pull/5717)
* Use local jetty DTDs for configuration by @line-o [#5727](https://github.com/eXist-db/exist/pull/5727)
* Fix failing Linux jar installer by @reinhapa [#5678](https://github.com/eXist-db/exist/pull/5678)

## Updated Application Dependencies

* Update ant from 1.10.14 to 1.10.15
* Update bifurcan 0.2.0-alpha7 to 0.2.0-rc1
* Update bcprov-jdk18on from 1.78.1 to 1.88
* Update commons-codec from 1.16.0 to 1.18.0
* Update commons-compress 1.22 to 1.27.1
* Update commons-io from 2.15.1 to 2.18.0
* Update commons-lang3 from 3.14.0 to 3.17.0
* Update commons-logging from 1.3.0 to 1.3.5
* Update commons-pool2 2.12.0 to 2.12.1
* Update fastutil 8.5.12 to 8.5.15
* Update j8fu from 1.23.0 to 1.24.0
* Update jackson-core from 2.15.2 to 2.18.3
* Update java-uuid-generator 4.3.0 to 5.1.0
* Update jctools-core from 4.0.2 to 4.0.5
* Update jetty from 9.4.54.v20240208 to 9.4.57.v20241219
* Update jing from 20220510 to 20241231
* Update jline 3.25.1 to 3.29.0
* Update rsyntaxtextarea from 3.3.4 to 3.6.0

## Updated Build System Dependencies

* Switch to a new Maven Nexus repository at repo.exist-db.org
* Update appbundler-maven-plugin from 3.0.0 to 3.2.0
* Update IzPack from 5.2.0 to 5.2.4

**Full Changelog**: [compare the changes from eXist-6.3.0 to eXist-6.4.0](https://github.com/eXist-db/exist/compare/eXist-6.3.0...eXist-6.4.0)

## Backwards Compatibility

eXist-db 6.4.0 is backwards binary compatible with all previous 6.x.x releases. This should make upgrading simple with no changes required to XQuery or XSLT application code.
For those users migrating from 4.x.x or 5.x.x versions to 6.x.x a full backup and restore of the database will be required and possibly some small changes to XQuery and XSLT application code. Please review previous releases' notes for detailed information.

**NOTE:** `system:get-module-load-path#0` will now always return the load path of the _current_ context. 
If you need to get the module load path of the root context then you need to call `system:get-main-module-load-path#0` instead.
