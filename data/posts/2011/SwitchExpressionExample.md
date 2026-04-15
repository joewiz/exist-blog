---
title: "Switch Expression"
date: 2011-03-13
author: "Dannes Wessels"
tags:
  - "howto"
status: published
migrated-from: AtomicWiki
original-id: "SwitchExpressionExample"
original-blog: "HowTo"
original-url: "https://exist-db.org/exist/apps/wiki/HowTo/SwitchExpressionExample"
---

The Switch Expression is a welcome [addition](http://www.w3.org/TR/xquery-30/#id-switch%20) to the XML Query Language. This example presents its potential.

xquery version "3.0"; let $animal := "Cat" return switch ($animal) case "Cow" case "Calf" return "Moo" case "Cat" return "Meow" case "Duck" return "Quack" default return "What's that odd noise?"

returns

Meow

Note the sequence of switch case clauses

case "Cow" case "Calf" return "Moo"

sharing the same return expression.

*The expression is available starting eXist-db 1.5*