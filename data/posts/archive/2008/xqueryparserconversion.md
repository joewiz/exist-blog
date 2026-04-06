---
title: "words in mouth"
date: 2008-01-30
author: ljo
tags: []
status: published
migrated-from: AtomicWiki
original-id: XQueryParserConversion
original-url: https://exist-db.org/exist/apps/wiki/blogs/ljo/XQueryParserConversion
---


# NOTE: This post was auto-migrated from AtomicWiki and may need manual review.

# XQuery parser conversion I have been struggling with converting the XQuery parser from antlr2 to the somewhat incomplete and feature lacking antlr3 for the better part of the last fortnight. Should we maybe wait for 3.1 to make the features settle? This said, using the 2008-01-23.10 build right now which behaves a little bit better than the 3.0.1 released version. Well, to the more positive news are that the grammars compile since Sunday and I now am trying to fix the stuff that is not working in some more or less orderly fashion. The ANTLRWorks tool is really a nifty piece of software for remote debugging of the tree parser. Good work! For unit testing of the grammars I am playing around with the gUnit testsuite which later on can produce jUnit code for the lot, nice! Just to keep you updated 2008-02-12 The current baseline for the new parser on the eXist testsuite is 38.38% ... stay tuned.