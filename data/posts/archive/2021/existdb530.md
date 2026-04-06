---
title: "eXist-db 5.3.0"
date: 2021-06-26
author: juri
tags: [release, article]
category: release, article
status: published
migrated-from: AtomicWiki
original-id: eXistdb530
original-url: https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb530
---

# eXist-db 5.3.0 Release Notes

It’s been quite a while since the last release. A lot has been happening behind the scenes, and we are happy to share the outcome with you.

This release is binary compatible with eXist-db 5.2.0.

## Breaking changes

- Before upgrading an eXist 5.2.0 or earlier system to eXist 5.3.0 (or as soon as possible after upgrading), be sure to upgrade **existdb-packageservice** to the latest release, version 1.3.13 or higher. Since Dashboard relies on this library for all package-related operations, this upgrade must be performed outside Dashboard. To upgrade this package outside of Dashboard, either submit the following query to eXist via eXide or the Java Admin Client as an admin user:

```xquery
xquery version "3.1";

repo:remove("http://exist-db.org/apps/existdb-packageservice"),
repo:install-and-deploy("http://exist-db.org/apps/existdb-packageservice", 
    "http://exist-db.org/exist/apps/public-repo/find")
```

- The **shared resources** and **markdown** packages are no longer bundled with eXist-db. If your application depends on those you can still declare dependencies on them in your package metadata and download them from the [package repository](https://exist-db.org/exist/apps/public-repo/index.html).
- **eXide**’s app generator function has been removed from eXide v3.0.0, as part of important improvements to the application. For generating apps, please use the much better yeoman-based [generator-exist](https://github.com/eXist-db/generator-exist) tool.
- **Dashboard** v2.0.8 has [a known issue](https://github.com/eXist-db/dashboard/issues/194) that can cause requests a 404 error to appear after logging in to the administrative section. Until a permanent fix has been discovered, you can clear the affected browser of this problem by logging out and back in via eXide or Monex.
- The default eXist-db configuration settings are **not production ready**. Make sure to consult our [article on best practices ](https://exist-db.org/exist/apps/doc/production_good_practice.xml) before making your eXist-db instance publicly available. The new [existdb-config](https://github.com/eXistSolutions/existdb-config) project implements these "best practices" and can easily be used to harden your eXist-db(s) from version 5.1.1 till 5.3.0. 

## Highlights

### XQuery 3.1 compatibility

- Improved handling of the XQuery type system - [#3363](https://github.com/exist-db/exist/pull/3363), [#3266](https://github.com/exist-db/exist/pull/3266), [#3728](https://github.com/exist-db/exist/pull/3728), [#3791](https://github.com/exist-db/exist/pull/3791)
- Function types are now allowed as values in context item expressions
- Duplicate functions will reliably throw a useful error
- Root context is shielded from user defined functions
- Several fixes for positional predicates 
- When errors are thrown in XQuery most of them will now have useful location information
- Fixed parser issues to allow empty function body, and allow `||` in attribute and element content
- Allow other seed types in fn:random-number-generator (like dates) - [#3072](https://github.com/eXist-db/exist/pull/3072)
- Fixed the cardinality of fn:random-number-generator#1 - [#3249](https://github.com/eXist-db/exist/pull/3249)
- Improved `fn:format-number` - [#3348](https://github.com/eXist-db/exist/pull/3348)
- Made `fn:collection` spec compliant - [#3349](https://github.com/eXist-db/exist/pull/3349)
- Allow sequences for batch deletions in `map:remove` and `array:remove` - [#3328](https://github.com/eXist-db/exist/pull/3228), [#3692](https://github.com/eXist-db/exist/pull/3692)

### New functions added

- `array:sort` - [#3596](https://github.com/eXist-db/exist/pull/3596)
- `fn:document-uri#0` - [#3644](https://github.com/eXist-db/exist/pull/3644)
- `fn:trace#1` - [#3597](https://github.com/eXist-db/exist/pull/3597)
- `fn:xml-to-json` - [#3141](https://github.com/eXist-db/exist/pull/3141)

### Other enhancements

- Module handling and caching was improved significantly
- Both `controller.xq` and `controller.xql` are now recognized in apps that use eXist's URL Rewriting facility, to conform with the community convention of `.xq` for main modules and `.xqm` for library modules.
- The implementation of maps was changed to gain performance
- Allow Bearer tokens and other schemes than "Basic" in Authentication header
- Allow HTTP verb PATCH
- Custom base64 handling code was replaced with apache.commons code and a new function `util:base64-encode-url-safe` was added
- Enhanced `util:eval` to preserve the original error information
- In Lucene, you can now use different analyzers for indexing and querying

### Bundled apps

- All bundled applications have their frontend dependencies updated.
- The index view in **monex** now lists new fields and facets - [#124](https://github.com/eXist-db/monex/pull/124).
- See the next section which lists several issues affecting apps included in the eXist 5.3.0 distribution.

### Licensing

A lot of effort was poured into getting eXist-db’s source code licensed properly. It is now consistently LGPL 2.1, with exceptions where code from other projects is used with their permission.

## Features

-  change packages bundled with eXist-db - [#3939](https://github.com/exist-db/exist/pull/3939)
-  Backport of sql:close-connection from FusionDB - [#3890](https://github.com/exist-db/exist/pull/3890)
-  Connection Pooling for SQL Module - [#3831](https://github.com/exist-db/exist/pull/3831)
-  Replace Bintray URLs with GitHub Releases - [#3844](https://github.com/exist-db/exist/pull/3844) 
-  Add Code Coverage - [#3341](https://github.com/exist-db/exist/pull/3341)
-  Import repo logging - [#3814](https://github.com/exist-db/exist/pull/3814)
-  Look for controller.xq before controller.xql - [#3757](https://github.com/exist-db/exist/pull/3757)
-  add support for HTTP PATCH - [#3745](https://github.com/exist-db/exist/pull/3745)
-  Remove timeout on Compiled XQuery Pool - [#3721](https://github.com/exist-db/exist/pull/3721)
-  Remove jQuery - [#3715](https://github.com/exist-db/exist/pull/3715)
-  Add useful switches in the readme - [#3710](https://github.com/exist-db/exist/pull/3710) 
-  Broker pool service api - [#3705](https://github.com/exist-db/exist/pull/3705) 
-  Improve backup-ui dialog flow - [#3678](https://github.com/exist-db/exist/pull/3678)
-  wrap file stream writes into BufferedOutputStreams - [#3687](https://github.com/exist-db/exist/pull/3687) 
-  Make servlets pluggable - [#3671](https://github.com/exist-db/exist/pull/3671)
-  Add sonarcloud - [#3654](https://github.com/exist-db/exist/pull/3654)
-  Implement fn:document-uri#0 - [#3644](https://github.com/exist-db/exist/pull/3644)
-  Feature/add missing fn:trace - [#3597](https://github.com/exist-db/exist/pull/3597)
-  Add a parameter to util:eval to preserve the original error message - [#3588](https://github.com/exist-db/exist/pull/3588)
-  Enable conf.xml option document/@use-path-locks - [#3603](https://github.com/exist-db/exist/pull/3603) 
-  Implement array:sort - [#3596](https://github.com/exist-db/exist/pull/3596) 
-  Add details of where to find the XAR source-code - [#3593](https://github.com/exist-db/exist/pull/3593) 
-  fn:replace and fn:analyze-string are now implemented with Saxon - [#3530](https://github.com/exist-db/exist/pull/3530) 
-  add util:base64-encode-url-safe - [#3544](https://github.com/exist-db/exist/pull/3544)
-  Add a caller attribute to the output of system:get-running-xqueries#0 - [#3527](https://github.com/exist-db/exist/pull/3527)
-  support match highlighting on ft:field hits - [#3423](https://github.com/exist-db/exist/pull/3423)
-  Offer further build profiles - [#3386](https://github.com/exist-db/exist/pull/3386)
-  Update collection.xconf.xsd for eXist 5 - [#3379](https://github.com/exist-db/exist/pull/3379)
-  Improve XQuery test naming - [#3368](https://github.com/exist-db/exist/pull/3368)
-  Add memory and nr of processors information to startup log. - [#3335](https://github.com/exist-db/exist/pull/3335)
-  Group managers are loaded from security database at startup - [#3332](https://github.com/exist-db/exist/pull/3332) 
-  Allow disabling building of the IzPack installer - [#3326](https://github.com/exist-db/exist/pull/3326)
-  A more performant implementation of immutable maps - [#1520](https://github.com/exist-db/exist/pull/1520)
-  Make builds runtime compatible with Java 8 when built on JDK9+ - [#3320](https://github.com/exist-db/exist/pull/3320)
-  Switch to nonblocking free ids processing algorithms - [#3291](https://github.com/exist-db/exist/pull/3291)
-  Make Quartz Scheduler properties easily configurable - [#3274](https://github.com/exist-db/exist/pull/3274)
-  Multiple resources can have their permissions set in the JAC - [#3263](https://github.com/exist-db/exist/pull/3263)
-  Include the path of any file that could not be restored in the log - [#3268](https://github.com/exist-db/exist/pull/3268)
-  Switch README.md link for JDK from Oracle to AdoptOpenJDK - [#3260](https://github.com/exist-db/exist/pull/3260)
-  distinct analyzers for indexing and querying with Lucene - [#3227](https://github.com/exist-db/exist/pull/3227) 
-  Implement fn:xml-to-json() - [#3141](https://github.com/exist-db/exist/pull/3141)
-  Update IntelliJ config for 5.3.0-SNAPSHOT - [#3232](https://github.com/exist-db/exist/pull/3232) 
-  Pass args to release plugin - [#3223](https://github.com/exist-db/exist/pull/3223)

## Fixes 

- Further tests for Cache Module and a small NPE avoidance fix - [#3935](https://github.com/exist-db/exist/pull/3935)
- include templating in installer and tests - [#3941](https://github.com/exist-db/exist/pull/3941)
- add Java16 to build matrix and allow failures - [#3921](https://github.com/exist-db/exist/pull/3921)
- Cleanup all module contexts - [#3897](https://github.com/exist-db/exist/pull/3897)
- Fix arity in XQuery error when there are duplicate functions in a main module - [#3910](https://github.com/exist-db/exist/pull/3910)
- Block creation of collection by guest - [#3899](https://github.com/exist-db/exist/pull/3899)
- Very Small fixes - [#3908](https://github.com/exist-db/exist/pull/3908)
- throw error in repo:get-resource if file does not exist - [#3896](https://github.com/exist-db/exist/pull/3896)
- Further attempt to get Coveralls plugin working - [#3894](https://github.com/exist-db/exist/pull/3894)
- Specify the COVERALLS_TOKEN in the correct way for CI - [#3891](https://github.com/exist-db/exist/pull/3891)
- Fixes for SSL - [#3884](https://github.com/exist-db/exist/pull/3884)
- Lazily created caches should be bounded - [#3877](https://github.com/exist-db/exist/pull/3877)
- Block startup for Java 12-15 to protect from data corruption - [#3545](https://github.com/exist-db/exist/pull/3545)
- Remove object retained by inner-class via back-reference - [#3878](https://github.com/exist-db/exist/pull/3878)
- Avoid unauthorised creation of collections - [#3870](https://github.com/exist-db/exist/pull/3870)
- Improve invoking logger using log4j2 and slf4j templating - [#3830](https://github.com/exist-db/exist/pull/3830)
- Repair missing tmp dir TemporaryFileManager - [#3829](https://github.com/exist-db/exist/pull/3829)
- test the feature in container - [#3823](https://github.com/exist-db/exist/pull/3823)
- Eliminate SequencedLongHashMap custom code - [#3782](https://github.com/exist-db/exist/pull/3782)
- repair appveyor build - [#3811](https://github.com/exist-db/exist/pull/3811)
- reimplement fn:base-uri() - [#3813](https://github.com/exist-db/exist/pull/3813)
- Fixes corrupted stream message with maven-surefire-plugin - [#3810](https://github.com/exist-db/exist/pull/3810)
- Fix URL for build status page and badge - [#3808](https://github.com/exist-db/exist/pull/3808)
- repair build CQL Parser Module - [#3807](https://github.com/exist-db/exist/pull/3807)
- NPE on predicates with an empty sequence - [#3799](https://github.com/exist-db/exist/pull/3799)
- Fix incomplete type error reporting - [#3791](https://github.com/exist-db/exist/pull/3791)
- Tests for computed namespace constructor - [#3781](https://github.com/exist-db/exist/pull/3781)
- Make CI more manageable - [#3766](https://github.com/exist-db/exist/pull/3766)
- Speed up CI when Docker Images are built - [#3771](https://github.com/exist-db/exist/pull/3771)
- fn:position() off-by-one after any predicate - [#3761](https://github.com/exist-db/exist/pull/3761)
- Fix a regression in finding the roots of the type hierarchy - [#3774](https://github.com/exist-db/exist/pull/3774)
- Fix storage of repo.xml during package installation - [#3773](https://github.com/exist-db/exist/pull/3773)
- Fix typo in error message for system:get-running-jobs - [#3772](https://github.com/exist-db/exist/pull/3772)
- Fix GitHub Actions for SonarCloud - [#3664](https://github.com/exist-db/exist/pull/3664)
- GitHub CI Badge in README.md should be for the `develop` branch - [#3765](https://github.com/exist-db/exist/pull/3765)
- Add Docker to CI and tweak CI settings - [#3760](https://github.com/exist-db/exist/pull/3760)
- Further fixes to CI - [#3756](https://github.com/exist-db/exist/pull/3756)
- Fix typo in CI config - [#3755](https://github.com/exist-db/exist/pull/3755)
- Improve CI in GitHub Actions - [#3751](https://github.com/exist-db/exist/pull/3751)
- Creates a build matrix on github actions - [#3743](https://github.com/exist-db/exist/pull/3743)
- Group membership is not correct immediately after restoring a backup - [#3731](https://github.com/exist-db/exist/pull/3731)
-  xs:anyType is the top of a Type hierarchy, don’t look further - [#3728](https://github.com/exist-db/exist/pull/3728)
- Fix NaN comparisons - [#3729](https://github.com/exist-db/exist/pull/3729)
- Reinstate fix for output directory - [#3714](https://github.com/exist-db/exist/pull/3714)
- Update conf.xml XSD to latest conf.xml changes; fix location - [#3703](https://github.com/exist-db/exist/pull/3703)
- Proposed fix for #3624 NPE at RangeQueryRewriter.rewriteLocationStep - [#3625](https://github.com/exist-db/exist/pull/3625)
- Use fixed user environment for tests - [#3669](https://github.com/exist-db/exist/pull/3669)
- (Bugfix) misc XQTS reported issues - [#3693](https://github.com/exist-db/exist/pull/3693)
- Prevent NPEs in math:* functions. Tested in XQTS suite - [#3691](https://github.com/exist-db/exist/pull/3691)
- Array: extend remove() function to allow multiple deletes in one go. (XQTS) - [#3692](https://github.com/exist-db/exist/pull/3692)
- Remove old (unfinished?) code - [#3686](https://github.com/exist-db/exist/pull/3686)
- Fix for #3688 - [#3689](https://github.com/exist-db/exist/pull/3689)
- basic authentication - [#3670](https://github.com/exist-db/exist/pull/3670)
- Make import statements consistent in whole repo - [#3658](https://github.com/exist-db/exist/pull/3658)
- Update README.md - [#3656](https://github.com/exist-db/exist/pull/3656)
- add location info to element content errors - [#3550](https://github.com/exist-db/exist/pull/3550)
- Make sure the correct context sequence is used with util:eval-with-context - [#3529](https://github.com/exist-db/exist/pull/3529)
- Preserve original error message when using util:eval - [#3648](https://github.com/exist-db/exist/pull/3648)
- Fix root node handling and implicit context in functions - [#3605](https://github.com/exist-db/exist/pull/3605)
- Fix compilation issue with JAXB dependencies on JDK 11+ - [#3643](https://github.com/exist-db/exist/pull/3643)
- Another round of codebase improvements - [#3631](https://github.com/exist-db/exist/pull/3631)
- Fixing some resource management issues - [#3630](https://github.com/exist-db/exist/pull/3630)
- code improvements - [#3580](https://github.com/exist-db/exist/pull/3580)
- 0 byte sized binary resources can be included in ZiPfile - [#3566](https://github.com/exist-db/exist/pull/3566)
- allow function types in context item - [#3496](https://github.com/exist-db/exist/pull/3496)
- Small code improvements - [#3626](https://github.com/exist-db/exist/pull/3626)
- Fix NPE and Deadlock when Path Locks are used for Documents - [#3622](https://github.com/exist-db/exist/pull/3622)
- Remove code which duplicates Commons IO - [#3621](https://github.com/exist-db/exist/pull/3621)
- Log a warning if a collection.xconf is binary - [#3613](https://github.com/exist-db/exist/pull/3613)
- Avoid IllegalStateException in Http Session functions - [#3612](https://github.com/exist-db/exist/pull/3612)
- Improve module code quality - [#3611](https://github.com/exist-db/exist/pull/3611)
- Update CI to include Java15 - [#3609](https://github.com/exist-db/exist/pull/3609)
- REST API should not always complain about aborted transactions - [#3604](https://github.com/exist-db/exist/pull/3604)
- Fix various problems with importing modules - [#3585](https://github.com/exist-db/exist/pull/3585)
- line and column numbers in unknown-atomic-type errors - [#3546](https://github.com/exist-db/exist/pull/3546)
- Improve Module Source - [#3579](https://github.com/exist-db/exist/pull/3579)
- Fix an NPE in XQuery Update Replace - [#3576](https://github.com/exist-db/exist/pull/3576)
- Integration tests for SQL Module Connection Functions - [#3574](https://github.com/exist-db/exist/pull/3574)
- more improvements - [#3571](https://github.com/exist-db/exist/pull/3571)
- Allow Travis CI JDK14 job to fail - [#3572](https://github.com/exist-db/exist/pull/3572)
- Fix QName comparison Namepool - [#3570](https://github.com/exist-db/exist/pull/3570)
- Proposed fix for NPE with empty case expression - [#3567](https://github.com/exist-db/exist/pull/3567)
- Refactor/some more improvements - [#3569](https://github.com/exist-db/exist/pull/3569)
- Some generic code improvements - [#3568](https://github.com/exist-db/exist/pull/3568)
- allow functions with empty body - [#3552](https://github.com/exist-db/exist/pull/3552)
- added missing directoryScanner.scan(); to fix repo:install-from-db - [#3564](https://github.com/exist-db/exist/pull/3564)
- Remove document metadata indirection - [#3535](https://github.com/exist-db/exist/pull/3535)
- Simplify test setup - [#3537](https://github.com/exist-db/exist/pull/3537)
- Update to Apache Commons Collections 4 - [#3538](https://github.com/exist-db/exist/pull/3538)
- Collection must be persisted when renaming/moving - [#3534](https://github.com/exist-db/exist/pull/3534)
- Consistent License Declarations - [#3305](https://github.com/exist-db/exist/pull/3305)
- Fix an issue in the query history in the Java Admin Client - [#3528](https://github.com/exist-db/exist/pull/3528)
- Fix EXPath XAR required eXist-db version calculation - [#3319](https://github.com/exist-db/exist/pull/3319)
- Fix javadocs - [#3516](https://github.com/exist-db/exist/pull/3516)
- Fix an issue with the context item as an argument to fn:string-length inside a predicate - [#3508](https://github.com/exist-db/exist/pull/3508)
- Fixes to shutdown when running tests - [#3509](https://github.com/exist-db/exist/pull/3509)
- fn:base-uri should not raise XPDY0002 when the context item is empty - [#3498](https://github.com/exist-db/exist/pull/3498)
- concatenation dependend on mode - [#3493](https://github.com/exist-db/exist/pull/3493)
- Small cleanup to fn:matches code - [#3492](https://github.com/exist-db/exist/pull/3492)
- Catch exception and enrich exception with location information - [#3478](https://github.com/exist-db/exist/pull/3478)
- Make sure the blob.dbx is present in the data backup - [#3480](https://github.com/exist-db/exist/pull/3480)
- Small Code cleanup - [#3481](https://github.com/exist-db/exist/pull/3481)
- Get location from predicate evaluation and add to exception - [#3469](https://github.com/exist-db/exist/pull/3469)
- Command line scripts support SSL - [#3453](https://github.com/exist-db/exist/pull/3453)
- Fix formatting of am/pm for 12 pm - [#3458](https://github.com/exist-db/exist/pull/3458)
- add missing location from error messages - [#3452](https://github.com/exist-db/exist/pull/3452)
- Fix link to book - [#3451](https://github.com/exist-db/exist/pull/3451)
- Improve signing of release artifacts - [#3443](https://github.com/exist-db/exist/pull/3443)
- Small fixes - [#3442](https://github.com/exist-db/exist/pull/3442)
- Add java modules to list functions - [#3430](https://github.com/exist-db/exist/pull/3430)
- Repair module prefixes - [#3428](https://github.com/exist-db/exist/pull/3428)
- Make sure that dist-archives are built by default - [#3412](https://github.com/exist-db/exist/pull/3412)
- Fix issues with types and comparisons - [#3363](https://github.com/exist-db/exist/pull/3363)
- java exception on higher order functions - [#3364](https://github.com/exist-db/exist/pull/3364)
- Add functioning invite link to eXist Cmty Slack - [#3399](https://github.com/exist-db/exist/pull/3399)
- use v1 syntax - [#3397](https://github.com/exist-db/exist/pull/3397)
- fix deployment syntax on travis - [#3396](https://github.com/exist-db/exist/pull/3396)
- Fix Travis Deploy step - [#3385](https://github.com/exist-db/exist/pull/3385)
- Small change to util:node-by-id to avoid unexpected NPE - [#3383](https://github.com/exist-db/exist/pull/3383)
- Reduces JDK pipeline to the LTS and last released versions - [#3381](https://github.com/exist-db/exist/pull/3381)
- Fix an NPE with Security Context in dynamically loaded modules - [#3377](https://github.com/exist-db/exist/pull/3377)
- Use secure maven repos where possible - [#3374](https://github.com/exist-db/exist/pull/3374)
- Switch to new OSGeo repo - [#3373](https://github.com/exist-db/exist/pull/3373)
- Avoid IndexOutOfBounds when selecting combo box items in JAC - [#3353](https://github.com/exist-db/exist/pull/3353)
- rename test to clarify goal - [#3369](https://github.com/exist-db/exist/pull/3369)
- Small Travis config improvements - [#3359](https://github.com/exist-db/exist/pull/3359)
- Prohibit duplicate function declarations - [#3354](https://github.com/exist-db/exist/pull/3354)
- Context Item should not be atomized when used as argument for fn:string-length - [#3355](https://github.com/exist-db/exist/pull/3355)
- Add OpenJDK 12 and 13 to Travis CI - [#3340](https://github.com/exist-db/exist/pull/3340)
- fn:collection should only return XML documents - [#3349](https://github.com/exist-db/exist/pull/3349)
- Fix bounds issues with group separators in fn:format-number - [#3348](https://github.com/exist-db/exist/pull/3348)
- Remove system.out message for debugging - [#3351](https://github.com/exist-db/exist/pull/3351)
- Fix util:get-resource-by-absolute-id - [#3350](https://github.com/exist-db/exist/pull/3350)
- Fix an issue with positional predicates that have multiple values - [#3333](https://github.com/exist-db/exist/pull/3333)
- Fix an issue with Java equality of DLN - [#3328](https://github.com/exist-db/exist/pull/3328)
- Avoid an NPE when reconstructing nested stack traces - [#3327](https://github.com/exist-db/exist/pull/3327)
- Fix casting integers as union type xs:numeric - [#3324](https://github.com/exist-db/exist/pull/3324)
- Fix polluted context when dynamically compiling query - [#3325](https://github.com/exist-db/exist/pull/3325)
- Fix renaming a Collection - [#3314](https://github.com/exist-db/exist/pull/3314)
- Don’t keep the splash screen in front of everything else - [#3315](https://github.com/exist-db/exist/pull/3315)
- Fix the UTF8 decoding of Node Values - [#3317](https://github.com/exist-db/exist/pull/3317)
- Add missing test names - [#3306](https://github.com/exist-db/exist/pull/3306)
- Take the XQJ API dependency from Maven Central - [#3302](https://github.com/exist-db/exist/pull/3302)
- Refactor system:export - [#3303](https://github.com/exist-db/exist/pull/3303)
- Ensure Inspect Module functions throws errors appropriately - [#3297](https://github.com/exist-db/exist/pull/3297)
- Update Jing and switch to official artifact - [#3298](https://github.com/exist-db/exist/pull/3298)
- boolean-sequences.xql Test was in the wrong location - [#3292](https://github.com/exist-db/exist/pull/3292)
- Docker HEALTHCHECK should use `guest` account not `admin` - [#3288](https://github.com/exist-db/exist/pull/3288)
- Fix some issues with document-node type checks - [#3287](https://github.com/exist-db/exist/pull/3287)
- Fix some small Windows Service issues - [#3283](https://github.com/exist-db/exist/pull/3283)
- Fix restoring folder backups on Windows via XML:RPC - [#3282](https://github.com/exist-db/exist/pull/3282)
- With fn:unparsed-text#1 non-dba users should only be restricted from filesystem - [#3285](https://github.com/exist-db/exist/pull/3285)
- fn:concat requires an arity of at least two when making a function reference - [#3286](https://github.com/exist-db/exist/pull/3286)
- fn:parse-xml-fragment should return a document-node() - [#3290](https://github.com/exist-db/exist/pull/3290)
- Fix reporting of Restored Documents when restoring a backup - [#3271](https://github.com/exist-db/exist/pull/3271)
- Resolve XSLT Modules from EXPath Packages - [#3258](https://github.com/exist-db/exist/pull/3258)
- Document URI was incorrectly cached during a Collection Move - [#3269](https://github.com/exist-db/exist/pull/3269)
- Fix type conversion of xs:positiveInteger and xs:negativeInteger types - [#3266](https://github.com/exist-db/exist/pull/3266)
- Descriptor file should be read from $EXIST_HOME/etc - [#3267](https://github.com/exist-db/exist/pull/3267)
- Correctly set the sticky bit when using a simple symbolic mode string - [#3270](https://github.com/exist-db/exist/pull/3270)
- Make sure the Memtree in the query context is correctly used - [#3262](https://github.com/exist-db/exist/pull/3262)
- Make sure the context is preserved when dynamically compiling a query - [#3265](https://github.com/exist-db/exist/pull/3265)
- Reinstate code for a historical Jetty bugfix - [#3261](https://github.com/exist-db/exist/pull/3261)
- Fix the cardinality of fn:random-number-generator#1 - [#3249](https://github.com/exist-db/exist/pull/3249)
- Fix an issue with jetty closing sockets - [#3248](https://github.com/exist-db/exist/pull/3248)
- spec compliant random-number-generator - [#3072](https://github.com/exist-db/exist/pull/3072)
- map:remove sequence of keys - [#3228](https://github.com/exist-db/exist/pull/3228)


## Dependencies

- Bump Saxon-HE from 9.9.1-6 to 9.9.1-7 
- Bump ant.version from 1.10.7 to 1.10.10 
- Bump apache.httpcomponents.version from 4.5.11 to 4.5.13 
- Bump aspectj-maven-plugin from 1.12.1 to 1.12.6 
- Bump bcprov-jdk15on from 1.64 to 1.69 
- Bump bifurcan from 0.2.0-alpha1 to 0.2.0-alpha6 
- Bump caffeine from 2.8.1 to 2.9.1 
- Bump commons-codec from 1.14 to 1.15 
- Bump commons-compress from 1.18 to 1.20 
- Bump commons-configuration2 from 2.6 to 2.7 
- Bump commons-io from 2.6 to 2.10.0 
- Bump commons-lang3 from 3.9 to 3.12.0 
- Bump dependency-check-maven from 5.2.4 to 6.2.2 
- Bump docker-maven-plugin from 0.33.0 to 0.36.0 
- Bump download-maven-plugin from 1.5.0 to 1.6.3 
- Bump easymock from 4.1 to 4.3 
- Bump exec-maven-plugin from 1.6.0 to 3.0.0 
- Bump exquery.distribution.version from 0.1.35 to 0.2.0 
- Bump fastutil from 8.3.0 to 8.5.4 
- Bump fop from 2.4 to 2.6 
- Bump hsqldb from 2.5.0 to 2.6.0 
- Bump http-client-java from 1.2.2 to 1.4.1 
- Bump httpcore from 4.4.13 to 4.4.14 
- Bump jackson-core from 2.10.2 to 2.12.3 
- Bump jacoco-maven-plugin from 0.8.6 to 0.8.7 
- Bump jakarta.activation from 1.2.1 to 2.0.0 
- Bump jakarta.mail from 1.6.4 to 1.6.5 
- Bump jakarta.xml.bind-api from 3.0.0 to 3.0.1 
- Bump jansi from 1.18 to 2.3.3 
- Bump java-uuid-generator from 3.2.0 to 4.0.1 
- Bump jaxb-impl from 3.0.0-M5 to 3.0.1 
- Bump jcstress-core from 0.5 to 0.13 
- Bump jctools-core from 3.0.0 to 3.3.0 
- Bump jetty.version from 9.4.26.v20200117 to 9.4.42.v20210604
- Bump jline from 3.13.3 to 3.20.0 
- Bump jmh.version from 1.22 to 1.32 
- Bump jts from 1.8 to 1.13 
- Bump junit from 4.13 to 4.13.2 
- Bump log4j.version from 2.13.0 to 2.14.1 
- Bump lz4-java from 1.7.1 to 1.8.0 
- Bump maven-assembly-plugin from 3.2.0 to 3.3.0 
- Bump maven-dependency-plugin from 3.1.1 to 3.1.2 
- Bump maven-javadoc-plugin from 3.1.1 to 3.3.0 
- Bump maven-project-info-reports-plugin from 3.0.0 to 3.1.2
- Bump maven-resources-plugin from 3.1.0 to 3.2.0
- Bump maven-shade-plugin from 3.2.1 to 3.2.4 
- Bump maven-site-plugin from 3.8.2 to 3.9.1 
- Bump maven-surefire-plugin from 3.0.0-M4 to 3.0.0-M5 
- Bump maven-surefire-report-plugin from 3.0.0-M4 to 3.0.0-M5
- Bump pkg-java from 1.4.2 to 1.6.1 
- Bump rsyntaxtextarea from 3.0.8 to 3.1.3 
- Bump tika.version from 1.23 to 1.26 
- Bump tools-java from 0.3.0 to 0.7.0 
- Bump versions-maven-plugin from 2.7 to 2.8.1 
- Bump xmlgraphics-commons from 2.4 to 2.6 
- Bump xmlunit.version from 2.6.3 to 2.8.2 
