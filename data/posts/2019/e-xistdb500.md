---
title: "eXist-db 5.0.0"
date: 2019-09-02
author: "aretter"
tags:
  - "release"
  - "article"
status: published
migrated-from: AtomicWiki
original-id: "eXistdb500"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb500"
---

# v5.0.0 - September 2nd, 2019

We are very happy to announce that eXist-db 5.0.0 has been released.

eXist-db 5 represents a substantial development effort, incorporating more than 1,400 commits from 26 contributors over the course of two and a half years.

The most significant improvements to this version of eXist-db involve collection and document locking. The focus of this effort firstly was to ensure "correctness" (i.e., to prevent database corruption) and secondly to improve concurrent performance (i.e., performance when many users are accessing the database) and reporting on the state of the system to aid developers and system administrators in diagnosing locking issues. These and other improvements detailed below aim to dramatically boost eXist-db's reliability and stability.

Other highlights of this release include that eXist-db has a new faceted browsing facility, supports more standard XQuery 3.1 functions, and is now built using Maven and is available via DockerHub. Read more about these and all of the improvements below. Be sure to read to the end for important notes about upgrading. 

## Features

* New Dashboard and Package Manager [#2438](https://github.com/eXist-db/exist/pull/2438).
* Improved the performance of the Lock Table [#2591](https://github.com/eXist-db/exist/pull/2591).
* Improved the performance of Lock Striping [#2831](https://github.com/eXist-db/exist/pull/2831).
* Optimized XMLString to reduce copying.
* Spatial Index is now available again [#2601](https://github.com/eXist-db/exist/pull/2601).
* Options can now be passed to `ft:search` queries.
* A leading wildcard can now be used in `ft:search` queries [#2468](https://github.com/eXist-db/exist/pull/2468).
* Added the new function `ft:index-keys-for-field` for the Lucene Index to complement `util:index-keys` for field indexes.
* Added support for faceting with the Lucene Index [#2629](https://github.com/eXist-db/exist/pull/2629). See the documentation for how to [attach fields or facets](http://exist-db.org/exist/apps/doc/lucene#facets-and-fields) to an indexed node, using XQuery expressions to select/construct content. Query across fields, use them for sorting or drill down into a query result using facets.
* Added XQuery 3.1 `fn:contains-token` [#2799](https://github.com/eXist-db/exist/pull/2799), `fn:parse-ietf-date`  [#2866](https://github.com/eXist-db/exist/pull/2866), and  `fn:random-number-generator` functions.
* Added the `system:get-product-name` function.
* Added the `xmldb:copy-resource` and `xmldb:copy-collection` functions.
* Rewrote the Service Manager for Windows platforms.
* Docker images now use an Uber jar for easy deployment.
* New Jar Installer based on IzPack 5.


## Updated Libraries

* Apache Ant 1.10.6
* Apache Commons Codec 1.13
* Apache Commons Compress 1.18
* Apache Commons Configuration 2.5
* Apache Commons Daemon 1.2.0
* Apache Commons File Upload 1.4
* Apache Commons HTTP Components 4.5.9
* Apache Commons Lang 3.9
* Apache Mina 2.1.2
* Apache Tika 1.22
* Bouncy Castle 1.62
* Caffeine 2.8.0
* cglib 3.3.0
* Eclipse AspectJ 1.9.4
* Eclipse Jetty 9.4.20.v20190813
* EXPath Pkg 1.4.1
* EXPath HTTP Client 1.2.0
* EXPath Tools 0.3.0
* FasterXML UUID Generator 3.2.0
* FastUtil 8.3.0
* IzPack 5.1.4
* j8fu 1.23.0
* Jackson 2.9.9
* JavaMail 1.6.3
* JLine 3.11.0
* Log4j 2.12.1
* LZ4 1.6.0
* MultiLock 1.0.1
* Quartz Scheduler 2.3.1
* RESTXQ 0.1.34
* RSyntaxTextArea 3.0.3
* Saxon HE 9.9.1-4
* SLF4j 1.7.28
* XMLUnit 2.6.3


## Bug Fixes
* Restoring a Backup no longer overwrites newer versions of apps (unless configured to do so) [#2985](https://github.com/eXist-db/exist/pull/2985).
* Added missing EXPath Packages to the IzPack installer [#2989](https://github.com/eXist-db/exist/pull/2989).
* Fixed a deadlock which can occur with System Tasks [#2984](https://github.com/eXist-db/exist/pull/2984).
* Improved log reporting when deploying EXPath packages [#2982](https://github.com/eXist-db/exist/pull/2982).
* Fixed first-start deployment of `collection.xconf.init` for enabling RESTXQ [#2978](https://github.com/eXist-db/exist/pull/2978).
* Added missing Semver.xq to autodeploy directory [#2975](https://github.com/eXist-db/exist/pull/2975).
* Fixed collation comparison on empty strings [#2967](https://github.com/eXist-db/exist/pull/2967).
* Improved the concurrent performance of the Compiled XQuery Pool [#2972](https://github.com/eXist-db/exist/pull/2973).
* Improved the Lock Table lease recording performance [#2963](https://github.com/eXist-db/exist/pull/2963).
* Small improvements to LDAP support [#2937](https://github.com/eXist-db/exist/pull/2937).
* Reinstate the bin scripts in the App produced for Mac platforms [#2931](https://github.com/eXist-db/exist/pull/2931).
* WebSocket Server again runs correctly in Docker Container [#2929](https://github.com/eXist-db/exist/pull/2929).
* Java Admin Client can now restore a backup with a different admin account password correctly [#2934](https://github.com/eXist-db/exist/pull/2834).
* Fixed the data folder path when restoring a backup to an embedded database [#2927](https://github.com/eXist-db/exist/pull/2927).
* Corrected the Mac artifact name to `eXist-db-$ver.dmg` [#2910](https://github.com/eXist-db/exist/pull/2910).
* Fixed a User account leak in XQuery User Switching Function [#2924](https://github.com/eXist-db/exist/pull/2624).
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

We have removed the Java Web Application Archive (WAR) build of eXist-db. We no longer support running eXist-db inside a 3rd-party Servlet container such as Apache Tomcat. If you wish to operate eXist-db as a Server, you should instead run the server using the provided Jetty start-up scripts.

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

Craig Berry has kindly provided a [Perl script](https://github.com/craigberry/audit_exist_5x_removals) which you can run against your XQuery code to audit for most of these changes.


## New Build System
The build system for eXist-db was previously Apache [Ant](https://ant.apache.org/). With 5.x.x we have completed a full migration of the build system to Apache [Maven](https://maven.apache.org/). Maven affords us a much more modular, rigorous, and flexible process, whilst reducing the maintenance burden that we experienced with Ant. We are now also able to easily publish [artifacts to Maven Central](https://search.maven.org/search?q=g:org.exist-db) for those eXist-db users that embed eXist-db within their own applications.

One major change, is that eXist-db can no longer be built "in-place" from a Git clone, instead building eXist-db now generates a distribution. It is recommended that all users working with the source code, should start with a fresh clone of eXist-db 5.0.0, as its source footprint is not compatible with 5.0.0-RC7 or older.

The *Building eXist-db* documentation page has been updated with the latest instructions for building eXist-db with Maven.



## Backwards Compatibility

eXist-db 5.0.0 is binary compatible with eXist-db RC8, RC7, and RC6. Regardless, before upgrading to this version of eXist-db, it is strongly recommended to perform a full backup and restore. Users who are upgrading should always consult the [Upgrading Guide](https://exist-db.org/exist/apps/doc/upgrading.xml) in the documentation. For details of backwards compatibility with versions of eXist-db prior to 5.0.0-RC6, please see the Backwards Compatibility details of [5.0.0-RC6](http://www.exist-db.org/exist/apps/wiki/blogs/eXist/eXistdb500RC6).

**NOTE**: Applications that shipped with previous version of eXist-db are not guaranteed to be forwards compatible. To ensure smooth operation you should clear your web browser's cache before trying to access newer apps.

## Downloading this Version
* eXist-db v5.0.0 is available for download from [GitHub](https://github.com/eXist-db/exist/releases/tag/eXist-5.0.0).
* Docker images for are available from eXist-db's [DockerHub](https://hub.docker.com/r/existdb/existdb/tags/).
* Maven artifacts are available from [Maven Central](https://search.maven.org/search?q=g:org.exist-db).
* Mac users of the [Homebrew](http://brew.sh) package repository may acquire eXist 5.0.0 directly from there via. the `exist-db` cask.

## High Scores!
We would like to say a big *Thank You* to all of those developers who contributed to eXist-db 5.0.0. Your contributions were very welcome.

<table>
	<tr>
		<th>Name</th>
		<th>Commits</th>
		<th>Baddies Defeated</th>
	</tr>
	<tr>
		<td>Adam Retter</td>
		<td>872</td>
		<td>60.51 %</td>
	</tr>
	<tr>
		<td>Dannes Wessels</td>
		<td>231</td>
		<td>16.03 %</td>
	</tr>
	<tr>
		<td>Wolfgang Meier</td>
		<td>97</td>
		<td>6.73 %</td>
	</tr>
	<tr>
		<td>Duncan Paterson</td>
		<td>95</td>
		<td>6.59 %</td>
	</tr>
	<tr>
		<td>Dependabot</td>
		<td>43</td>
		<td>2.98 %</td>
	</tr>
 	<tr>
                <td>Joe Wicentowski</td>
                <td>36</td>
                <td>2.50 %</td>
        </tr>
	<tr>
		<td>Patrick Reinhart</td>
		<td>12</td>
		<td>0.83 %</td>
	</tr>
	<tr>
		<td>Magdalena Turska</td>
		<td>12</td>
		<td>0.83 %</td>
	</tr>
	<tr>
		<td>Juri Leino</td>
		<td>7</td>
		<td>0.49 %</td>
	</tr>
	<tr>
		<td>Lars Windauer</td>
		<td>4</td>
		<td>0.28 %</td>
	</tr>
	<tr>
		<td>Leif Jöran-Olsson</td>
		<td>4</td>
		<td>0.28 %</td>
	</tr>
	<tr>
		<td>Opax</td>
		<td>3</td>
		<td>0.21 %</td>
	</tr>
	<tr>
		<td>Peter Stadler</td>
		<td>3</td>
		<td>0.21 %</td>
	</tr>
	<tr>
		<td>Dmitriy Shabanov</td>
		<td>2</td>
		<td>0.14 %</td>
	</tr>
	<tr>
		<td>Peter Hungerburg</td>
		<td>2</td>
		<td>0.14 %</td>
	</tr>
	<tr>
		<td>Olaf Schreck</td>
		<td>2</td>
		<td>0.14 %</td>
	</tr>
	<tr>
		<td>Otmar Humbel</td>
		<td>2</td>
		<td>0.14 %</td>
	</tr>
	<tr>
		<td>Stanislav Jordanov</td>
		<td>2</td>
		<td>0.14 %</td>
	</tr>
	<tr>
		<td>Bert Willems</td>
		<td>1</td>
		<td>0.07 %</td>
	</tr>
	<tr>
		<td>Bruce Robertson</td>
		<td>1</td>
		<td>0.07 %</td>
	</tr>
	<tr>
		<td>Claudius Teodorescu</td>
		<td>1</td>
		<td>0.07 %</td>
	</tr>
	<tr>
		<td>Ioannis Cherouvim</td>
		<td>1</td>
		<td>0.07 %</td>
	</tr>
	<tr>
		<td>Marcel Schaeben</td>
		<td>1</td>
		<td>0.07 %</td>
	</tr>
	<tr>
		<td>Marcelo Duarte Trevisani</td>
		<td>1</td>
		<td>0.07 %</td>
	</tr>
	<tr>
		<td>Mathias Goebel</td>
		<td>1</td>
		<td>0.07 %</td>
	</tr>
	<tr>
		<td>Mike Jones</td>
		<td>1</td>
		<td>0.07 %</td>
	</tr>
</table>


