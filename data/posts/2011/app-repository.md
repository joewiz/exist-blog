---
title: "Demo of the new app repository"
date: 2011-09-14
author: "admin"
tags: []
status: published
migrated-from: AtomicWiki
original-id: "AppRepository"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/AppRepository"
---

eXist's development version (to become v1.5) provides a number of new features to simplify the process of creating, deploying and distributing XQuery-based apps. An "app" in this context is a self-contained package, which can be downloaded from a public or private repository and installed into any instance of eXist-db with a few mouse clicks. The app may just package a bunch of XQuery library modules or (REST-style) interfaces, or it may contain an entire, complex web application.

There are many different paths to create an application with eXist, which is good. But this also makes it difficult for new users to find their way. The new app repository as well as eXide try to simplify the process for people to get started (just keep in mind that not every app will fit into this framework).

Upon request, I created a short screencast to demonstrate how simple it is to use the package repository to install entire applications into eXist. This is just a teaser and does not explain how to actually create app packages. I have a longer video in the pipeline which explains just that (eXide actually handles most of the setup work for you).


For the next release of eXist, we plan to ship all example code and parts of the documentation as apps, which can be installed on demand. This will lead to a cleaner installation and make it easier for people to find their way through the examples.
