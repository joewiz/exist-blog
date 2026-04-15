---
title: "XQuery 3.0 Implementation Notes"
date: 2012-04-09
author: "admin"
tags:
  - "howto"
status: published
migrated-from: AtomicWiki
original-id: "XQ3Notes"
original-blog: "HowTo"
original-url: "https://exist-db.org/exist/apps/wiki/HowTo/XQ3Notes"
---

The XQuery 3.0 specification introduces a number of additions to the language. eXist-db 2.0 already supports most of the new language constructs.

To use XQuery 3.0 features, your query or module must start with an XQuery declaration specifying version "3.0":

    xquery version "3.0";

The following notes cover selected features:

- [Switch Expression](SwitchExpressionExample): a switch on atomic values
- [Try-Catch Expressions](Try-CatchExpression): error handling
- [Group by clauses](GroupByClause) in FLWOR expressions: eXist had an extension for group by clauses since 2006. It has not been aligned with the XQuery 3.0 specs yet, but is nevertheless very useful.