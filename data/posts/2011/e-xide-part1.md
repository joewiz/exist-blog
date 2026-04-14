---
title: "Introducing eXide - A web-based XQuery IDE (Part 1)"
date: 2011-04-29
author: "wolf"
tags: []
status: published
migrated-from: AtomicWiki
original-id: "eXidePart1"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/eXidePart1"
---

Features include: fast syntax highlighting, ability to edit huge XQuery files, code completion for functions and variables, code templates, powerful navigation, on-the-fly compilation...

This is the first part of my screencast. The second part will cover the application development cycle, including code generation (scaffolding), deployment and synchronization.


eXide is now available in SVN trunk ([]()). After updating, just open `http://localhost:8080/exist/eXide/` in your browser. The application uses some HTML5 features (local storage, CSS3) and has been tested with recent versions of Firefox (3.5/4.0), Chromium and Safari. Internet Explorer won't work (I'm sure it can be fixed but I did not want to go through it yet).

Special thanks to the []() project for developing the core editor component. It is a pleasure to build an IDE around it.
