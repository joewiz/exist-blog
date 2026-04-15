---
title: "eXist-db in a NutShell"
date: 2007-12-06
author: "Dannes Wessels"
tags:
  - "community"
status: published
migrated-from: AtomicWiki
original-id: "proposal"
original-blog: "dizzzz"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/dizzzz/proposal"
---

eXist-db is an open source database management system entirely built on XML technology. It is a "Native XML Database" which means the database does not store XML data "as is" but eXist will transform the XML data into its own internal logical model.

eXist-db uses XQuery to retrieve and manipulate data. The database supports many (web) technology standards making it an excellent application platform:

- XQuery 1.0 / XPath 2.0
- XSLT [1.0](http://www.w3.org/TR/xslt) (using Apache Xalan) or XSLT [2.0](http://www.w3.org/TR/xslt20) (optional using [Saxon](http://saxon.sourceforge.net) )
- HTTP interfaces: REST, webDAV, SOAP, XMLRPC, Atom Publishing Protocol
- XML database specific: XMLDB, XQJ/[JSR-225](http://jcp.org/en/jsr/detail?id=225) (under development)

eXist-db is highly compliant with the [XQuery](http://www.w3.org/TR/xquery/) standard (current [XQTS](http://www.w3.org/XML/Query/test-suite/) score is 99.4%) for the standard functions for querying data but it has also additional (non w3c) XQuery Update Extensions for updating (insert, replace, value delete and rename) data stored in the database. Out of the box eXist-db also provides a large collection of XQuery Function Modules containing many handy functions that are not (yet) defined in the XQuery specification.

The eXist-db has a large community of users and developers, which is very active. For more information and documentation please visit our [homepage](http://www.exist-db.org).

For even more information or support please consult our [WiKi](http://atomic.exist-db.org/) or [search](http://www.nabble.com/eXist-f4072.html) or [subscribe](https://lists.sourceforge.net/lists/listinfo/exist-open) to our mailing list. Alternatively visit us on our AJAX based [chatbox](http://irc.exist-db.org/irclog/index.html).

eXist-db has been developed in the Java programming language (Java 1.4 or newer, SUN java preferred) and the sources are available on SourceForge [subversion](http://sourceforge.net/svn/?group_id=17691) repositories. The [OpenSource](http://www.ohloh.net/projects/252?p=eXist) code is made [browsable](http://www.koders.com/info.aspx?c=ProjectInfo&#x26;amp;pid=VUM641QG5USW5EHRSLWDSDVM6G) and is continuously [monitored](http://fisheye3.cenqua.com/browse/exist/) and [built](http://parabuild.viewtier.com:8080/parabuild/index.htm?cid=b26f).