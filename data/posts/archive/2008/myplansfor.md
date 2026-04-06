---
title: "My Plans for 1.2.x and 1.3.x"
date: 2008-01-22
author: dizzzz
tags: []
status: published
migrated-from: AtomicWiki
original-id: MyPlansfor
original-url: https://exist-db.org/exist/apps/wiki/blogs/dizzzz/MyPlans/MyPlansfor
---


# NOTE: This post was auto-migrated from AtomicWiki and may need manual review.

On this page I'll write down my plans for eXist-db, just like I would do on a paper notebook. Environment friendly, because no paper is involved here :-) # 1.2.3 - nothing planned, main development for 1.3.x # 1.3.x - Support alternative Parsers by configuration: make robust for e.g. picolo parser. - Move build.xml downloaded files to properties file, and use template - Implement []() - Implement []() (RFE 1747855) - Document 'group by' usage - Document new ant task - Add test []() / deep-equals - Redesign webstart / find context - Make more configuration / status info available via JMX - Add more request:- functions available, e.g. check for SSL connection - Copy conf.xml to /db/system/... upon db start for backup purposes. # JMX management - (done) dbx files: sizes - (done) transaction logs: count, sizes - transcript conf.xml (?) - free disk space - HTTP proxy settings (dynamic configuration) - db-broker details (who uses, threads, interface) - SaxParser pool statistics - GrammarCache statistics - database uptime? - free diskspace report in case free diskspace &amp;#x3c; 250 Mb (2.5 times theoretical max on transaction journal file size). # Validation - (done) Start with alternative validation stuff (schematron, relaxng, ...) - (done) validation; add relaxng/schematron - Make configurable ; caching, resolver. - Redesign parser and xslt version check. - Pre-parse grammar and store in cache. - Re-design parser configuration (from cache) - Get rid of validation added data # Project - Add FAQ to wiki, scan ML for recurring questions (how to build, svn, modules) - Describe XSL-FO in wiki - Precompile all modules, store at existdb-contrib site - Update conf.xml; reduce commented blocks, defaults should be OK - Write 'How to make dist" ; steps like updating build.properties. # Postpone - Check ivy stuff for downloading external jars.