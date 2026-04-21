---
title: "eXist-db v3.1.0 available"
date: 2017-03-07
author: "ljo"
tags:
  - "release"
status: published
migrated-from: AtomicWiki
original-id: "eXist310"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/eXist310"
---

# Release Notes

## v3.1.0 - March 7, 2017

We are very pleased to announce the release of eXist-db v3.1.0.

We encourage everyone to upgrade to this latest release. It is the culmination of changes since the release of v3.0 26 days ago, on February 9, 2017, and brings new features and numerous improvements, detailed below. Most notably of these: eXist-db releases now follow the "semantic versioning" (semver) convention; it adds support for XQuery 3.1 features and improves those already supported; and shutdown and package management were made more robust. 

### New Features

- Implemented the Arrow Operator (`=>`) from XQuery 3.1
- Implemented String Constructors from XQuery 3.1
- Implemented [`fn:has-children`]({docs}/functions/fn/has-children), [`fn:innermost`]({docs}/functions/fn/innermost), and [`fn:outermost`]({docs}/functions/fn/outermost) functions from XQuery 3.1
- Extended the Range Index conditions feature

### Performance Improvements

- FLWOR `where` clauses are no longer evaluated for empty sequences, resulting in significant speed increase

### Critical Bug Fixes

- Fixed the shutdown timer
- Improved EXPath Package repository stability in cases of failures or corruption 
- Replaced some additional read locks with write locks where required
- AuditTrailSessionListener now releases locks correctly
- Variable names without namespace prefix are now correctly in no namespace 

### Clean Up and Refactoring

- Refactored many tests
- Simplified the [`sql:execute`]({docs}/functions/sql/execute) function and corrected the encoding of its results
- Function definitions are no longer shared between deferred function calls
- All FLWOR clauses except `where` clauses are now pre-evaluated
- Added tests for range index conditions
- IntelliJ, NetBeans, and Eclipse configuration files cleaned up
- Map and Array constructors are now inlined in grammar
- Improved the Lookup Operator (`?`) for postfix expressions with Maps from XQuery v3.0
- Continued clean up of eXist-db's Test Suite
- Added integration tests to ensure EXPath Package functionality and further support the trimming of the core
- Extended use of SystemExitCodes instead of explicit integers
- Improved the service wrapper (yajsw) introduced in v3.0
- Made the [`ft:query-field`]({docs}/functions/ft/query-field) only depend on context sequence
- Removed support for Launch4j exe creation
- Fixed short form of shutdown arguments 
- Upgraded 3rd party libraries:
    - log4j2
    - Switched to use Jargo instead of defunct Excalibur (and Guava) 
- ... and many more 

### Backwards Compatibility

- eXist-db v3.1.0 is binary-compatible with v3.0 but not with previous versions. Users upgrading from previous versions should perform a full backup and restore to migrate their data.
- eXist-db v3.1.0 and v3.0 require Java 8.
- Due to the legacy Full Text Index being removed, the `text` XQuery module (`http://exist-db.org/xquery/text`) has also been removed. Users should now rely on the [`fn:analyze-string`]({docs}/functions/fn/analyze-string) function, e.g.:
    - Instead of using `text:groups()`, use `analyze-string()//fn:group`,
    - Instead of `text:filter("apparat", "([pr])")`, use `analyze-string("apparat", "([pr])")//fn:match/string()`
- There have been changes to some internal APIs, e.g., XQueryService has been moved from DBBroker to BrokerPool.
- EXPath Packages that incorporate Java libraries may no longer work with eXist-db v3.1.0 and may need to be recompiled for our API changes; packages should now explicitly specify the eXist-db versions that they are compatible with.

### Downloading This Version

eXist-db v3.1.0 is available for download from [GitHub](https://github.com/eXist-db/exist/releases/tag/eXist-3.1.0). (The older Sourceforge download page is no longer updated.) Maven artifacts for eXist-db v3.1.0 are available from our [mvn-repo](https://github.com/eXist-db/mvn-repo). Mac users of the [Homebrew](http://brew.sh) package repository will be able to install and upgrade shortly; an announcement will be made on the exist-open mailing list.

## Development

All of the [changes that went into eXist-db v3.1.0](https://github.com/eXist-db/exist/compare/develop@{26day}...develop)
 can be viewed via this link on GitHub.