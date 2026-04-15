---
title: "eXist 1.2.5 & 1.3 and OxygenXML"
date: 2008-12-31
author: "Dannes Wessels"
tags:
  - "howto"
status: published
migrated-from: AtomicWiki
original-id: "eXistXmlRpcChanged"
original-blog: "HowTo"
original-url: "https://exist-db.org/exist/apps/wiki/HowTo/eXistXmlRpcChanged"
---

Here's the complete list of drivers needed to establish recent *eXist 1.2.5+ and 1.4.x* builds to oXygen as a data source (via oXygen's Options -- Preferences -- Data Sources -- Data Sources -- eXist -- Data Sources Drivers):

- exist/exist.jar
- exist/lib/core/xmldb.jar
- exist/lib/core/xmlrpc-client-3.1.3.jar
- exist/lib/core/xmlrpc-common-3.1.3.jar
- exist/lib/core/ws-commons-util-1.0.2.jar

source: [Mailinglist](http://markmail.org/message/4b3cvof7tumomn5h)

For the older *eXist 1.2* versions the instructions are found [here](http://www.oxygenxml.com/eXist_support.html) and [here](http://www.oxygenxml.com/eXist.html).