---
title: "AtomicWiki: An Atom-based Wiki"
date: 2007-10-19
author: "wolf"
tags: []
status: published
migrated-from: AtomicWiki
original-id: "AtomicWiki"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/AtomicWiki"
---

What you can see here is a first live version of *AtomicWiki*, my XQuery-based Wiki engine. AtomicWiki started as an experiment to create a simple blog on top of eXist's existing *Atom* support. Eventually, more and more features were added during the past months, so the project has more evolved into a wiki-style system than "just" a weblog.

AtomicWiki is entirely based on the *Atom Publishing Protocol* and syndication format. All entries are stored as Atom feeds in eXist. We use the Atom Publishing Protocol to create and manipulate feeds and entries. Nearly all the functionality - except one Java function for parsing Wiki markup - is implemented in XQuery with the help of some XSLT and Javascript.

What makes AtomicWiki really powerful though, is its tight integration with XQuery!

Read more about AtomicWiki: []()
