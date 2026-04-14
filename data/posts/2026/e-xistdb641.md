---
title: "eXist-db 6.4.1"
date: 2026-03-06
author: "juri"
tags:
  - "release"
  - "news"
  - "article"
status: published
migrated-from: AtomicWiki
original-id: "eXistdb641"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb641"
---

<div>

<div class="section">

## Release Notes

We are pleased to announce version 6.4.1 of eXist-db. This is a small patch release, that addresses minor issues found in the last release.

**Note:** Unfortunately, the MacOS DMG is still not accepted by the Gatekeeper. This will be addressed with the next major version of eXist-db.

<div class="section">

### Bug Fixes

- Fix type conversion to Saxon types in fn:transform by @nverwer in [\#5882](https://github.com/eXist-db/exist/pull/5882)
- Fix Monex query history by generating unique keys by @nverwer in [\#5881](https://github.com/eXist-db/exist/pull/5881)
- Fix formatting of small numbers with exponents by @dizzzz in [\#5954](https://github.com/eXist-db/exist/pull/5954)
- Fix an error thrown in the JMX servlet at server startup by @dizzzz in [\#5835](https://github.com/eXist-db/exist/pull/5835)
- Fix macOS testing in CI by @duncdrum in [\#5852](https://github.com/eXist-db/exist/pull/5852)
- Fix uploading the log on failure in CI by @duncdrum in [\#5849](https://github.com/eXist-db/exist/pull/5849)
- Deprecate Cardinality \_MANY by @reinhapa in [\#6005](https://github.com/eXist-db/exist/pull/6005)
- Fix the version of two submodule poms by @line-o in [5788](https://github.com/eXist-db/exist/pull/5788)

### Updated Application Dependencies and Build System Dependencies

- Updating 3rd party libraries and build plugins by @dizzzz in [6013](https://github.com/eXist-db/exist/pull/6013)

**Full Changelog:** [compare the changes from eXist-6.4.0 to eXist-6.4.1](https://github.com/eXist-db/exist/compare/eXist-6.4.0...eXist-6.4.1)

### Backwards Compatibility

eXist-db 6.4.1 is backwards binary compatible with all previous 6.x.x releases. This should make upgrading simple with no changes required to XQuery or XSLT application code. For those users migrating from 4.x.x or 5.x.x versions to 6.x.x a full backup and restore of the database will be required and possibly some small changes to XQuery and XSLT application code. Please review previous releases' notes for detailed information.

</div>

</div>

</div>
