---
title: "Try-Catch Expression"
date: 2011-03-13
author: "admin"
tags:
  - "howto"
status: published
migrated-from: AtomicWiki
original-id: "Try-CatchExpression"
original-blog: "HowTo"
original-url: "https://exist-db.org/exist/apps/wiki/HowTo/Try-CatchExpression"
---

The Try-Catch Expression is another welcome [addition](http://www.w3.org/TR/xquery-30/#id-try-catch%20) to the XML Query Language. This page introduces the expression and provides some examples.

## XQuery 1.0

While the first version of the xquery language provided the possibility to raise errors, the language had no standard mechanism to handle these errors. The following two queries show how it works:

xquery version '1.0'; 7 + "a"

results in `"XPTY0004: `` can not be an operand for +"`

xquery version '1.0'; xmldb:store('/db/not-existent/', 'test.xml', &lt;a/&gt;)

results into `"Could not locate collection: /db/not-existent/"`

For a long time eXist-db provided a custom mechanism to handle these errors with the  function. An example:

xquery version '1.0'; util:catch( "\*", 7 + "a" , "handle error" )

Additional information about the error can be obtained from two variables which are set by the function:

$util:exception , $util:exception-message

For more details check the eXist-db function [documentation](http://demo.exist-db.org/exist/functions/util/catch%20).

## XQuery 3.0

In version 3.0 of XQuery language the handling of errors has become part of the language: the try-catch expression. An introduction example:

xquery version '3.0'; try { (try expression) } catch (catch error list or "\*") { (catch expression) }

The "catch error list" specifies wich errors are handled in the next catch expression; the asterix wildcard is an special example meaning all errors match.

It is possible to have more catch clauses, the values in the catch-error-list determines which catch block is executed.

The following query is a nice complete example of the try-catch expression. The outcome of the query is `2`:

xquery version '3.0'; try { 'a' + 7 } catch err:XPTY0001 | err:XPTY0002 { 1 } catch err:XPTY0004 { 2 } catch err:XPDY0003 | err:XPDY0005 { 3 } catch \* { 4 }

The java exception of the second example can be handled as well:

xquery version '3.0'; try { xmldb:store('/db/not-existent/', 'test.xml', &lt;a/&gt;) } catch java:org.xmldb.api.base.XMLDBException { "b" }

Finally it is possible to raise and handle an xquery error using the  function:

xquery version '3.0'; try { fn:error( fn:QName('http://www.w3.org/2005/xqt-errors', 'err:FOER0000') ) } catch err:FOER0000 { $err:code , $err:description, $err:value }

For more details check the examples in the [specification](http://www.w3.org/TR/xquery-30/#id-try-catch%20) and in the corresponding [usecases](http://www.w3.org/TR/xquery-30-use-cases/#try-catch-use-cases%20). These examples are integrated into our test suite.

*The expression is available starting eXist-db 1.5 ; in Jan 2012 changes were made to reflect the latest specification*