---
title: "How to create eXist-db installers"
date: 2008-05-19
author: "Wolfgang Meier"
tags:
  - "community"
status: published
migrated-from: AtomicWiki
original-id: "IZPackAndLaunch4J"
original-blog: "dizzzz"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/dizzzz/IZPackAndLaunch4J"
---

The procedure is not too complicated....

First download all relevant files.....

- Download code from SVN/sf.net `svn co trunk`.
- Download the izPack software from <http://izpack.org/downloads/> and install.
- Download Launch4J from <http://launch4j.sourceforge.net> and install.
- Download the required subversion jars with `./build.sh svn-download` Then....

<!-- -->

- (Optionally) prepare for signing jar files (e.g. running the Interactive Client via webstart): `./build.sh -f build/scripts/jarsigner.xml` Edit build.properties (for windows: write locations like )

<!-- -->

- edit <span class="strong">izpack.dir</span> to match the location above.
- edit <span class="strong">launch4j.dir</span> to match the location above.
- modify <span class="strong">xmldb.src</span> if you could find the files on internet.

> For an official eXist-db release we should rename e.g. 1.3.1dev into 1.3.1 !

Now you are ready to go. First build the code.... `./build.sh`

Check the content of the file VERSION.txt; the current SVN revision of the sf.net server should be visible here.

Build the installer you need....

- WAR: `./build.sh dist-war`
- JAR: `./build.sh installer`
- EXE: `./build.sh installer-exe` (creates JAR as well)