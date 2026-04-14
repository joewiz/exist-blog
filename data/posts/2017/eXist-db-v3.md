---
title: "eXist-db v3.0 available"
date: 2017-02-09
author: "ljo"
tags:
  - "release"
status: published
migrated-from: AtomicWiki
original-id: "eXist-db-v3"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/eXist-db-v3"
---

# Release Notes

## v3.0 - February 9, 2017
It is our great pleasure to announce the public stable release of eXist-db v3.0.

We encourage everyone to upgrade to this new stable release.  eXist-db
v3.0 is the culmination of almost 1,500 changes made in the last two
years bringing numerous new features and improvements. During this
time eXist-db went through extensive stress testing demonstrating
substantial performance gains confirmed in production settings.

### New Features
    - Support for XQuery v3.1, including the array and map data types,
    serialisation and JSON parsing 
    - Support for Braced URI Literals from XQuery v3.0
    - Facility to boost attributes in the Lucene full text index
    - eXist-db version detection for EXPath packages. Packages should explicitly specify which versions of
    eXist-db they are compatible with; eXist-db v2.2 is assumed by default.
    - Prototype support for Portable EXPath XQuery Extension Functions written in Haxe
    - New service wrapper, Yet another java service wrapper (yajsw)
    - New Jetty version (HTTP/2 etcetera)

### Improved Performance

    - Sequence type checking on recursive function parameters has been
    drastically sped up 
    - Lucene full-text and range indexes have been
    switched to "near realtime" behaviour. This improves query
    performance on frequently updated documents. 
    - Performance boost for new range index.
    - Improved optimisation of wildcard steps in path expressions, e.g. **prefix:** *and* **:name** 
    - Better performance for `util:eval` Optimisation of `fn:fold-left` and `fn:fold-right`

### Mission Critical Bug Fixes

There have been numerous bug fixes and enhancements since eXist-db
2.2, the most critical are:

    - Solved a potential deadlock which
    manifested when storing XQuery files into the database under
    certain conditions 
    - Fixed a memory leak when storing query
    results into the HTTP session; Web applications making use of
    the HTTP session should now consume less memory and scale further
    - Fixed an occasional deadlock when shutting down the
    database 
    - Fixes to match highlighting with the Lucene full text index
    - Lucene range index now correctly handles != comparisons
    - Substantial improvements in whitespace handling in mixed content  
    - Windows compatibility in service wrapper
    - Fixes in RESTXQ
    - Security fixes for privilege escalation 

### Clean up and Refactoring

    - Rewritten HTML5 Serializer
    - Rewritten XML:DB and XML-RPC APIs
    - Updated to the latest version of RESTXQ
    - Improved Java Admin Client document viewing and editing
    - Clean up of eXist-db's Test suite
    - Extensive internal refactoring to exploit new Java 8 features 
      - lambda expressions where possible
      - use of Optional
      - Java 7 auto closables
      -	NIO.2
    - Upgrades of 3rd party libraries:
      - Saxon HE 9.6.0-7
      - Jetty 9.3.9.v2016051
      - Lucene 4.10.4
      - Quartz 2.2.3
      - Log4j 2.7
      - FOP 2.1
      - Tika 1.12 (Content Extraction module)
      - betterForm 5.1-SNAPSHOT-20160615
      - and many more 
    - Removed legacy code:
      - SOAP API and SOAP Server
      - XACML Security feature
      - eXist's own Full-Text Index (replaced by eXist Lucene Full-Text Index)
      - Removed the Versioning extension; Now available as a separate EXPath Package

### Backwards Compatibility issues

    - eXist-db v3.0 is not binary compatible with previous versions of
    eXist-db; the on-disk database file format has been updated,
    users should perform a full backup and restore to migrate their data.
    - eXist.db v3.0 and subsequent versions now require Java 8;
    Users must update to Java 8!  
    - Due to the legacy Full Text Index being removed, 
    the `text` (http://exist-db.org/xquery/text) XQuery
    module has also been removed. Users should now look toward
    `fn:analyze-string`, e.g. 
      - instead of using `text:groups()` use `analyze-string()//fn:group`,
      - instead of `text:filter("apparat", "([pr])")` use `analyze-string("apparat", "([pr])")//fn:match/string()`) 
    - There have been changes to some of the internal APIs. e.g. `XQueryService` has
    been moved from `DBBroker` to `BrokerPool`.
    - EXPath packages that incorporate Java libraries may no longer work with eXist-db v3.0
    and may need to be recompiled for our API changes; packages
    should now explicitly specify the eXist-db versions that they
    are compatible with.

eXist-db v3.0 is available for download from
[GitHub](https://github.com/eXist-db/exist/releases/tag/eXist-3.0). The older
Sourceforge download page is no longer updated. Maven artifacts for
eXist-db v3.0 are available from our [Maven Repository](http://github.com/exist-db/mvn-repo).

## Development

For all details see our [commits](https://github.com/eXist-db/exist/compare/develop@{812day}...develop)

