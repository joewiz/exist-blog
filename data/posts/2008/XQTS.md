---
title: "XQTS"
date: 2008-09-28
author: "Adam Retter"
tags:
  - "howto"
status: published
migrated-from: AtomicWiki
original-id: "XQTS"
original-blog: "HowTo"
original-url: "https://exist-db.org/exist/apps/wiki/HowTo/XQTS"
---

In order to run the XQuery Test Suite (XQTS), you need to download and install the XQTS data from the W3C web site. To install and run the XQTS, read the following instructions:

- Get latest XQTS test suite ZIP file from the [W3C site](http://www.w3.org/XML/Query/test-suite/%20).
- Extract the file to a location remembered as "XQTS\_HOME" on your local drive (it is not needed to create an environment variable).
- Enable the File XQuery Extension module in <span class="strong">EXIST\_HOME\_HOME/conf.xml</span> (first enable in <span class="strong">EXIST\_HOME/extensions/build.properties</span> and <span class="strong">build.sh extension-modules</span> if necessary).
- Modify <span class="strong">EXIST\_HOME/webapp/xqts/config.xml</span>, set
  &lt;basedir&gt;XQTS\_HOME&lt;/basedir&gt;

  &lt;username&gt;admin&lt;/username&gt;

  &lt;password&gt;admin&lt;/password&gt;
- Modify <span class="strong">EXIST\_HOME/conf.xml</span><span class="strong"> set </span>suppress-whitespace="none"<span class="strong"> if required</span>
- set <span class="strong">disable-deprecated-functions="yes"</span> if required
- set <span class="strong">raise-error-on-failed-retrieval="yes"</span> if required

<span class="strong">:anyURI("/db"), "rwurwurwu")</span>

- Ensure that you have downloaded and copied icu4j-4\_8.jar to

  Unknown extension: EXIST

  \_HOME/lib/user to get the best Collation Support.

<!-- -->

- Start eXist as full server in <span class="strong">EXIST\_HOME</span>: `bin/startup.sh` or ` bin/startup.bat `
- Start data upload: ` build.(sh|bat) -f EXIST_HOME/webapp/xqts/build.xml `

<!-- -->

- After the data upload, Tests may be started by visiting  from a web-browser. Select a test suite Category and then click "Run Test" button (on the top right).