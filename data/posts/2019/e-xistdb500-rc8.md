---
title: "eXist-db 5.0.0 RC8"
date: 2019-08-01
author: "admin"
tags:
  - "release"
  - "article"
status: published
migrated-from: AtomicWiki
original-id: "eXistdb500RC8"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb500RC8"
---

# v5.0.0-RC8 - July 31, 2019

The eighth Release Candidate (RC) for eXist-db 5.0.0 has been released.

eXist-db 5.0.0-RC8 builds atop eXist-db 5.0.0-RC7 with several new features and important bug fixes.

NOTE: This is likely the last Release Candidate before 5.0.0 is released. We kindly ask all users to test their applications on RC8, and report back any new issues since RC7. The testing window for RC8 is between 2 and 4 weeks, dependant on any issues reported by users. All being well, 5.0.0 final will be released by 31st Aug 2019.


## Features

* New Dashboard and Package Manager [#2438](https://github.com/eXist-db/exist/pull/2438).
* Improved the performance of the Lock Table [#2591](https://github.com/eXist-db/exist/pull/2591).
* Improved the performance of Lock Striping [#2831](https://github.com/eXist-db/exist/pull/2831).
* Optimized XMLString to reduce copying.
* Spatial Index is now available again [#2601](https://github.com/eXist-db/exist/pull/2601).
* Options can now be passed to `ft:search` queries.
* A leading wildcard can now be used in `ft:search` queries [#2468](https://github.com/eXist-db/exist/pull/2468).
* Added the new function `ft:index-keys-for-field` for the Lucene Index to complement `util:index-keys` for field indexes.
* Added a `MetaAnalyzer` for the Lucene Index to allow different analyzers to be used per-field.
* Lucene Index definitions can now have a conditional expression provided in an `if` attribute.
* Added experimental support for Faceting with the Lucene Index [#2629](https://github.com/eXist-db/exist/pull/2629).
* Added the `fn:contains-token` function [#2799](https://github.com/eXist-db/exist/pull/2799).
* Added the `fn:parse-ietf-date()` function [#2866](https://github.com/eXist-db/exist/pull/2866).
* Added the `fn:random-number-generator` function.
* Added the `system:get-product-name` function.
* Added the `xmldb:copy-resource` and `xmldb:copy-collection` functions.
* Rewrote the Service Manager for Windows platforms.
* Docker images now use an Uber jar for easy deployment.
* New Jar Installer based on IzPack 5.


## Updated Libraries

* Apache Ant 1.10.6
* Apache Commons Codec 1.12
* Apache Commons Compress 1.18
* Apache Commons Configuration 2.4
* Apache Commons Daemon 1.2.0
* Apache Commons File Upload 1.4
* Apache Commons HTTP Components 4.4.11
* Apache Commons Lang 3.9
* Apache Mina 2.1.2
* Apache Tika 1.20
* Bouncy Castle 1.5.1
* cglib 3.2.12
* Eclipse AspectJ 1.9.4
* Eclipse Jetty 9.4.18.v20190429
* EXPath Pkg 1.4.0
* EXPath HTTP Client 1.2.0
* EXPath Tools 0.3.0
* FasterXML UUID Generator 3.2.0
* IzPack 5.1.4
* Jackson 2.9.8
* JavaMail 1.6.3
* JLine 3.11.0
* MultiLock 1.0.1
* Quartz Scheduler 2.3.1
* RESTXQ 0.1.34
* RSyntaxTextArea 3.0.3
* Saxon HE 9.9.1-2
* SLF4j 1.7.26


## Bug Fixes

* Added missing XML library dependencies for JDK 10+.
* Fixed non-spec compliant issues with `preceding-sibling` and `following-sibling` axes.
* Fixed a regression with XQuery Update's `insert following` expression [#2624](https://github.com/eXist-db/exist/pull/2624).
* Removed a bad optimization affecting expressions like `/a/b//c[d = 123]` [#2837](https://github.com/eXist-db/exist/pull/2837).
* `fn:tokenize` is now case-sensitive by default [#2742](https://github.com/eXist-db/exist/pull/2742).
* Fixed an issue where the content of XML Comments was incorrectly escaped [#2740](https://github.com/eXist-db/exist/pull/2740).
* Reduced the memory use and increased performance of file transfers in the XML:DB API [#2630](https://github.com/eXist-db/exist/pull/2630).
* Reduced the memory use and computation when sorting.
* Reduced the memory use of Collections [#2688](https://github.com/eXist-db/exist/pull/2688).
* Fixed an issue whereby XQSuite was not reporting all test failures [#2141](https://github.com/eXist-db/exist/pull/2141).
* Fixed a memory leak with QNames during XML serialization [#2537](https://github.com/eXist-db/exist/pull/2537).
* Fixed memory leaks with the `CharArrayPool` and `ByteArayPool`.
* Fixed an issue whereby eXist-db might not start correctly if Journal Recovery was disabled [#2539](https://github.com/eXist-db/exist/pull/2539).
* Fixed a regression with overlapping transactions when deploying EXPath packages.
* Made the parsing of `util:serialize` parameters conform with the function documentation.
* Ensure that all users have at least one Primary Group.
* Small fixes to the `EnsureLockingAspect`.
* Fixed an issue with the Namespace Constructor when there is an empty prefix [#2584](https://github.com/eXist-db/exist/pull/2584).
* Removed custom buggy Hash Table implementations in favour of those in [fastUtil](http://fastutil
fastutil.di.unimi.it/) [#2588](https://github.com/eXist-db/exist/pull/2588).
* Fixed Collection Locking when removing a Collection.
* Fixed the analysis of global variables when loading XQuery modules dynamically [#2580](https://github.com/eXist-db/exist/pull/2580).
* Fix an issue with replacing binary resources when owner/group differ from the active user [#2595](https://github.com/eXist-db/exist/pull/2595).
* Fixed purging of old zip backups [#2609](https://github.com/eXist-db/exist/pull/2609).
* Fixed a `NullPointerException` in `LDAPRealm` when searching for group members [#2618](https://github.com/eXist-db/exist/pull/2618).
* Corrected the order of arguments in `fn:for-each` and `fn:for-each-pair`.
* Fixed the context sequence for XQuery higher-order-functions [#2448](https://github.com/eXist-db/exist/pull/2448).
* Fixed an `ArrayOutOfBoundsException` when querying documents with enclosed expressions and the `fn:id` function [#2646](https://github.com/eXist-db/exist/pull/2646).
* Fixed a problem with Collation comparison on empty strings [#2671](https://github.com/eXist-db/exist/pull/2671).
* Fixed a problem with parallel sorting when using Collations [#2669](https://github.com/eXist-db/exist/pull/2669).
* Fixed an issue where descendent nodes were incorrectly indexed in the Lucene Index [#2682](ttps://github.com/eXist-db/exist/pull/2682).
* Fixed an issue with opening a Collection using a full XML:DB URL [#2693](https://github.com/eXist-db/exist/pull/2693).
* Avoid a `NullPointerException` in `AutoDeployment` when dependencies are not available.
* Made sure that the Launcher correctly exits when requested [#2730](https://github.com/eXist-db/exist/pull/2730).
* Fixed an issue where previously replacing a document, would not remove all prior nodes which caused storage to constantly grow.
* Fixed a locking issue when deleting documents via WebDAV [#2789](https://github.com/eXist-db/exist/pull/2789).
* Fixed a regression with YAJSW support introduced by adding `WRAPPER_UNATTENDED`.
* Fixed setting the admin password setting in the installer Jar.
* Fixed setting the data directory in the installer Jar.
* Fixed an issue whereby source locations were not correctly included in the installer Jar.
* Fixed JavaDoc syntax errors [#2860](https://github.com/eXist-db/exist/pull/2860).


## Removed

We have removed the Java Web Application Archive (WAR) build of eXist-db. We no longer support running eXist-db inside a 3rd-party Servlet container such as Apache Tomcat. If you wish to operate eXist-db as a Server, you should instead run it server using the provided Jetty start-up scripts.

We have also removed a number of previously deprecated functions, modules, and extensions:

* Removed the draft syntax for the XQuery Map Constructor, i.e. `map { "x" := "y"}` [#2892](https://github.com/eXist-db/exist/pull/2892).
* cache module:
	* `cache:cache`, caches are now created on demand.
* fn module:
	* `fn:map`, use the Map constructor instead.
	* `fn:map-pairs` function, you should instead use `fn:for-each-pair`.
	* `fn:string-pad`.
* image module:
	* `image:get-metadata`.
* map module:
	* `map:new` function, you should instead use the map constructor.
	* `map:for-each-entry`, you should instead use `map:for-each`.
* response module:
	* `response:set-response-header`, use `response:set-header` instead.
* sm module:
	* `sm:delete-group`, use `sm:remove-group` instead.
	* `sm:get-groups`
* util module:
	* `util:catch`, use XQuery 3.0's `try`/`catch` expression instead.
	* `util:eval-async`.
	* `util:parse`, use XQuery 3.0's `fn:parse-xml` or ` fn:parse-xml-fragment` instead.
	* `util:serialize`, use XQuery 3.0's `fn:serialize` instead.
* validation module:
	* `validation:validate`, you should use the other more specific functions within this module.
	* `validation:validate-report`, you should use the other more specific functions within this module.
* xmldb module:
	* `xmldb:add-user-to-group`, use `sm:add-group-member` instead.
	* `xmldb:change-user`, instead use various task specific functions in the `sm` module.
 	* `xmldb:chmod-collection`, use`sm:chmod` instead.
	* `xmldb:chmod-resource`, use `sm:chmod`, instead.
	* `xmldb:copy`, use `xmldb:copy-collection` and `xmldb:copy-resource` instead.
	* `xmldb:create-group`, use `sm:create-group` instead.
	* `xmldb:create-user`, use `sm:create-account` instead.
	* `xmldb:delete-user`, use `sm:remove-account` instead.
	* `xmldb:document`, use `fn:doc` instead.
	* `xmldb:exists-user`, use `sm:user-exists` instead.
	* `xmldb:get-current-user`, use `sm:id()//sm:real/sm:username/string()` instead.
	* `xmldb:get-current-user-attribute`, use `sm:get-account-metadata` instead.
	* `xmldb:get-current-user-attribute-names`, use `sm:get-account-metadata-keys` instead.
	* `xmldb:get-group`, use `sm:get-group` instead.
	* `xmldb:get-owner`, use `sm:get-permissions` instead.
	* `xmldb:get-user-groups`, use `sm:get-user-groups` instead.
	* `xmldb:get-user-home`.
	* `xmldb:get-user-primary-group`, use `sm:get-user-primary-group` instead.
	* `xmldb:get-users`, use `sm:list-users` instead.
	* `xmldb:group-exists`, use `sm:group-exists` instead.
	* `xmldb:is-admin-user`, use `sm:is-dba` instead.
	* `xmldb:is-authenticated`, use `sm:is-authenticated` or `sm:is-externally-authenticated` instead.
	* `xmldb:get-permissions`, use `sm:get-permissions` instead.
	* `xmldb:permissions-to-string`, use `sm:octal-to-mode` instead.
	* `xmldb:string-to-permissions`, use `sm:mode-to-octal` instead.
	* `xmldb:remove-user-from-group`, use `sm:remove-group-member` instead.
	* `xmldb:set-collection-permissions`, use `sm:chmod`, `sm:chown` and `sm:chgrp` instead.
	* `xmldb:set-resource-permissions`, use `sm:chmod`, `sm:chown` and `sm:chgrp` instead.

* XQuery Context module.
* XQuery DateTime module. Consider using [dtm.xqm](https://gist.github.com/adamretter/fcd8c99cf977ff31ad83dc37c4e49783) instead.
* eXist-db's HTTP Client module. Use the EXPath HTTP Client module instead.
* eXist-db's XQuery FTP Client module. Use the EXPath FTP Client module instead.
* eXist-db's Math module. Use the XQuery 3.0 math functions instead.
* commands extension.
* fluent extension.
* Memcached extension.
* metadata extension.
* netedit extension.
* OAuth Security extension.
* OpenID Security extension.
* Scheduler extension.
* tomcat-realm extension.
* XMPP extension.
* XProcXQ extension. Consider using Calabash instead.
* xUnit extension.

[Craig Berry has kindly provided](https://github.com/eXist-db/exist/issues/2626#issuecomment-484991704) a [Perl script](https://github.com/eXist-db/exist/files/3099085/audit_removals.pl.zip) which you can run against your XQuery code to audit for most of these changes.


## New Build System
The build system for eXist-db was previously Apache [Ant](https://ant.apache.org/). With RC8 we have completed a complete migration of the build system to Apache [Maven](https://maven.apache.org/). Maven affords us a much more modular and rigorous, and flexible process, whilst reducing the maintenance burden that we experienced with Ant. We are now also able to easily publish [artifacts to Maven Central](https://search.maven.org/search?q=g:org.exist-db) for those eXist-db users that embed eXist-db within their own applications.

One major change, is that eXist-db can no longer be built "in-place" from a Git clone, instead building eXist-db now generates a distribution. It is recommended that all users working with the source code, should start with a fresh clone of eXist-db RC8, as its source footprint is not compatible with RC7 and before.

The *Building eXist-db* documentation page has been updated with the latest instructions for building eXist-db with Maven.



### Backwards Compatibility

eXist-db 5.0.0-RC8 is binary compatible with eXist-db RC6 and RC7. Regardless, before upgrading to this version of eXist-db, it is strongly recommended to perform a full backup and restore. Users who are upgrading should always consult the [Upgrading Guide](https://exist-db.org/exist/apps/doc/upgrading.xml) in the documentation. For details of backwards compatibility with versions of eXist-db prior to 5.0.0-RC6, please see the Backwards Compatibility details of [5.0.0-RC6](http://www.exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb500RC6).

**NOTE**: EXPath Apps shipped with previous version of eXist-db, are not guaranteed to be forwards compatible with RC8. As such when restoring a backup to RC8 you should at least exclude the following from your `/db/apps` folder:
1. `/db/apps/dashboard`
2. `/db/apps/doc`
3. `/db/apps/eXide`
4. `/db/apps/fundocs`
5. `/db/apps/markdown`
6. `/db/apps/monex`
7. `/db/apps/packageservice`
8. `/db/apps/shared-resources`

If in doubt, you should consider excluding `/db/apps` entrirely from your backup archive during the restore, and then subsequently installing the latest versions of the Apps you need via the Dashboard's Package Manager.

You can selectively restore single collections by unzipping the backup and pointing the restore to a single  `__contents__.xml` file. This will only restore the corresponding collection.

An alternative approach would be:

1. restore the entire backup, taking into account that the dashboard won’t be available afterwards
2. open the Java admin client and issue an XQuery to update shared-resources and dashboard:

```
repo:remove("http://exist-db.org/apps/shared"),
repo:remove("http://exist-db.org/apps/dashboard"),
repo:install-and-deploy("http://exist-db.org/apps/shared", "http://exist-db.org/exist/apps/public-repo/find"),
repo:install-and-deploy("http://exist-db.org/apps/dashboard", "http://exist-db.org/exist/apps/public-repo/find“)
```

### Downloading this Version
* eXist-db v5.0.0-RC8 is available for download from [GitHub](https://github.com/eXist-db/exist/releases/tag/eXist-5.0.0-RC8).
* Docker images for are available from eXist-db's [DockerHub](https://hub.docker.com/r/existdb/existdb/tags/).
* Maven artifacts are available from [Maven Central](https://search.maven.org/search?q=g:org.exist-db).
* Mac users of the [Homebrew](http://brew.sh) package repository may acquire eXist 5.0.0-RC8 directly from there via. the `exist-db-rc` cask.