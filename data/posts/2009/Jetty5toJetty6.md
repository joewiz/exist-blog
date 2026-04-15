---
title: "Jetty5 to Jetty6 migration"
date: 2009-04-26
author: "Dannes Wessels"
tags:
  - "community"
status: published
migrated-from: AtomicWiki
original-id: "Jetty5toJetty6"
original-blog: "dizzzz"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/dizzzz/Jetty5toJetty6"
---

Recently I started to work on the upgrade of the webserver that is used internally by eXist-db: Jetty.

The migration from Jetty5 to Jetty6 turns out not to be straight forward, quite some things have changed there. Progress on this project will be posted here, together with links to important documentation.

- Upgrade of libraries done (done)
- ... added servlet-api-2.5-6.x.jar jetty-util-6.x.jar jetty-6.x.jar
- ... removed jasper jars ; we don't need them I think because we have no JSPs?
- Need to check Tomcat jar; can this file be deleted?
- We should move the servlet-api-jar in lib/core to /lib/optional ?

## Links

- [Porting to Jetty6](http://docs.codehaus.org/display/JETTY/Porting+to+jetty6%20)
- [Embedding jetty](http://docs.codehaus.org/display/JETTY/Embedding+Jetty%20)
- [Jetty6 Trial and Exploration](http://www.engidea.com/blog/informatica/jetty6/jetty6-explored.html%20)