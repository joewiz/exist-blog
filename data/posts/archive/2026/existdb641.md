---
title: "eXist-db 6.4.1"
date: 2026-03-06
author: juri
tags: [release, news, article]
category: release, news, article
status: published
migrated-from: AtomicWiki
original-id: eXistdb641
original-url: https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb641
---

<div>
    <body>
        <section>
            <h2>Release Notes</h2>
            <p>We are pleased to announce version 6.4.1 of eXist-db. This is a small patch release, that addresses minor issues found in the
last release.</p>
            <p><strong>Note:</strong> Unfortunately, the MacOS DMG is still not accepted by the Gatekeeper.
This will be addressed with the next major version of eXist-db.</p>
            <section>
                <h3>Bug Fixes</h3>
                <ul>
                    <li>Fix type conversion to Saxon types in fn:transform by @nverwer in <a href="https://github.com/eXist-db/exist/pull/5882">#5882</a></li>
                    <li>Fix Monex query history by generating unique keys by @nverwer in <a href="https://github.com/eXist-db/exist/pull/5881">#5881</a></li>
                    <li>Fix formatting of small numbers with exponents by @dizzzz in <a href="https://github.com/eXist-db/exist/pull/5954">#5954</a></li>
                    <li>Fix an error thrown in the JMX servlet at server startup by @dizzzz in <a href="https://github.com/eXist-db/exist/pull/5835">#5835</a></li>
                    <li>Fix macOS testing in CI by @duncdrum in <a href="https://github.com/eXist-db/exist/pull/5852">#5852</a></li>
                    <li>Fix uploading the log on failure in CI by @duncdrum in <a href="https://github.com/eXist-db/exist/pull/5849">#5849</a></li>
                    <li>Deprecate Cardinality _MANY by @reinhapa in <a href="https://github.com/eXist-db/exist/pull/6005">#6005</a></li>
                    <li>Fix the version of two submodule poms by @line-o in <a href="https://github.com/eXist-db/exist/pull/5788">5788</a></li>
                </ul>
                <h3>Updated Application Dependencies and Build System Dependencies</h3>
                <ul>
                    <li>Updating 3rd party libraries and build plugins by @dizzzz in <a href="https://github.com/eXist-db/exist/pull/6013">6013</a></li>
                </ul>

                <p><strong>Full Changelog:</strong> <a href="https://github.com/eXist-db/exist/compare/eXist-6.4.0...eXist-6.4.1">compare the changes from eXist-6.4.0 to eXist-6.4.1</a></p>
                
                <h3>Backwards Compatibility</h3>
                <p>
                    eXist-db 6.4.1 is backwards binary compatible with all previous 6.x.x releases. This should make upgrading simple with no changes required to XQuery or XSLT application code.
                    For those users migrating from 4.x.x or 5.x.x versions to 6.x.x a full backup and restore of the database will be required and possibly some small changes to XQuery and XSLT application code. Please review previous releases' notes for detailed information.</p>
            </section>
        </section>
    </body>
</div>