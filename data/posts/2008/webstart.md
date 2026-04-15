---
title: "My webstart client does not start (with log)"
date: 2008-08-22
author: "Wolfgang Meier"
tags:
  - "howto"
status: published
migrated-from: AtomicWiki
original-id: "webstart"
original-blog: "HowTo"
original-url: "https://exist-db.org/exist/apps/wiki/HowTo/webstart"
---

Probably you see something like

An error occurred while launching/running the application. Title: eXist XML-DB client Vendor: exist-db.org Category: Security Error Unsigned application requesting unrestricted access to system Unsigned resource: http://localhost:8080/exist/webstart/stax-api-1.0.1.jar

while the exception reads like:

JNLPException\[category: Security Error : Exception: null : LaunchDesc: &lt;jnlp spec="1.0+" codebase="http://localhost:8080/exist/webstart/" href="http://localhost:8080/exist/webstart/exist.jnlp"&gt;

The solution is to re-sign the jar files:

    build.sh -f build/scripts/jarsigner.xml jnlp-unsign-all jnlp-sign-all