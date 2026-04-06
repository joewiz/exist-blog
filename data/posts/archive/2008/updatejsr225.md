---
title: "Update on JSR-225"
date: 2008-11-28
author: dizzzz
tags: []
status: published
migrated-from: AtomicWiki
original-id: UpdateJsr225
original-url: https://exist-db.org/exist/apps/wiki/blogs/dizzzz/UpdateJsr225
---


# NOTE: This post was auto-migrated from AtomicWiki and may need manual review.

At this moment we are working on the XQJ a.k.a. jsr-225 drivers for the eXist database. We are quite close to integration the code into 1.3/trunk, small steps still need to be taken. For those who cannot wait: - [Subversion](http://exist.svn.sourceforge.net/viewvc/exist/branches/allad/jsr-225/) - [Specification](http://jcp.org/aboutJava/communityprocess/pfd/jsr225/index.html) The interface is tested in the junit test suite, but Oracle supplies a vendor independent testsuite as well. Due to licensing limitations this code cannot be included in the eXist-db distribution, but these can be downloaded easily. - Download the Oracle files with `./build.sh prepare-jsr225` remote: - For remote tests: start database `./bin/startup.sh` - Start the test suite: `./build.sh test-prepare test-jsr225-remote test-wrapup` - Check the results in `./test/junit/html/index.html` local: - Start the test suite: `./build.sh test-prepare test-jsr225-local test-wrapup`