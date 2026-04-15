---
title: "Java Webstart and Servlet containers"
date: 2008-09-06
author: "Dannes Wessels"
tags:
  - "community"
status: published
migrated-from: AtomicWiki
original-id: "TomcatIssues"
original-blog: "dizzzz"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/dizzzz/TomcatIssues"
---

This week there was [an issue reported](http://www.nabble.com/Question-about-the-webstart-admin-tt19314091.html#a19314091) concerning the code that enables the download of the InteractiveClient via [Java Webstart](http://en.wikipedia.org/wiki/Java_Web_Start). According to the report the code was not able to find the relevant jar files.

In short some context: `JnlpHelper.java ` retrieves information of the location of eXist and the jar files by calling `ConfigurationHelper.getExistHome() ` which -somehow- does not always return the right value. Since we had some issues before with this class, I wanted to try something else.

According to the servlet specification the best way of retrieving the location of files in a servlet context (on server extracted from war-file) is calling [getServletContext](http://java.sun.com/products/servlet/2.3/javadoc/javax/servlet/GenericServlet.html#getServletContext())().[getResource](http://java.sun.com/products/servlet/2.3/javadoc/javax/servlet/ServletContext.html#getResource(java.lang.String))("/") ; this should return a  styled URL to the toplevel directory of exist.

Unfortunately this does not work for tomcat. Tomcat does actually return a  type URL which cannot be resolved to a 'real' directory. There are several reports on this subject and is for us a dead end.

The other servlets of eXist-db use another construction to get the application directory information: getServletContext().[getRealPath](http://java.sun.com/products/servlet/2.3/javadoc/javax/servlet/ServletContext.html#getRealPath(java.lang.String))("/") but (quote: javadoc)

> The real path returned will be in a form appropriate to the computer and operating system on which the servlet container is running, including the proper path separators. This method returns null if the servlet container cannot translate the virtual path to a real path for any reason (such as when the content is being made available from a .war archive).

There were [some discussions](http://www.nabble.com/New-to-eXist---please-help%21--long--tt7204394.html#a7352116%20) on this a few years ago on the ML, but in the end it turns out that we do not have a real alternative than using getRealPath().

The consequence of this decision is that eXist-db cannot run in webcontainers that

- do not expand the war files when installed
- block access to the local filesystem. (This does not make sense anyhow, because exist does actually need to write data to 'some' file location.)

The webstart fix is now part of 1.3/trunk and 1.2.5.