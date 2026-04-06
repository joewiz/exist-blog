---
title: "Set alternative XML parser"
date: 2009-10-20
author: dizzzz
tags: []
status: published
migrated-from: AtomicWiki
original-id: SetAlternativeXMLparser
original-url: https://exist-db.org/exist/apps/wiki/blogs/dizzzz/SetAlternativeXMLparser
---


# NOTE: This post was auto-migrated from AtomicWiki and may need manual review.

I committed my changes into trunk (1.4!) that enable us to use an alternative XML parser in eXist. I tried the fast [Piccolo XML Parser for Java](http://piccolo.sourceforge.net/) but other JAXP compliant parsers should work as well. Note that the default Xerces jars must remain in lib/endorsed. - download the Piccollo jars from []() - install *Picollo.jar* into the `lib/user` directory set the `JAVA_OPTIONS` system environment: `export JAVA_OPTIONS="-Dorg.exist.SAXParserFactory=com.bluecast.xml.JAXPSAXParserFactory"` and start existdb with bin/startup.sh ; in the logging you'll see that then Piccolo parser is actually used. ## Need to know - When validation is switched on, Piccolo automagically switches to a validating parser: xerces in most cases. ## Known issues - While loading the mondial example data the mondial dtd is still resolved, resulting in an exception. - On quite some code locations SAXParserFactory is called directly. Need to figure out what makes sense to update.