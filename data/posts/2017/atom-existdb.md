---
title: "eXist Package for the Atom Editor"
date: 2017-02-20
author: "wolf"
tags:
  - "release"
status: published
migrated-from: AtomicWiki
original-id: "atom-existdb"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/atom-existdb"
---

This has been around for a while, but it was recently brought to my attention that many users don't know it exists: the [eXistdb](https://atom.io/packages/existdb) package for the [Atom](https://atom.io) editor was just released in version 0.4.1. Atom is a highly configurable, cross-platform text editor, which can be extended with thousands of user contributed packages.

The eXistdb package for Atom adds most of the functionality you know from eXide, including XQuery linting (via [xqlint](https://github.com/wcandillon/xqlint)), function and variable autocompletion, code navigation, a database browser, variable refactoring, code templates, and more. Unlike eXide it supports two different workflows for developing eXist apps:

1. all files stored within the database
2. work on a file system directory and have all changes synchronized into eXist automatically

## Try it

The package is considered stable and easy to install:

1. install Atom for your platform
2. open the Preferences page
3. select "Install", search for the "existdb" package and install it

![](https://i.github-camo.com/f871d45516c6e6c911f8111e1cb0add12ea6caa8/68747470733a2f2f7261772e67697468756275736572636f6e74656e742e636f6d2f776f6c6667616e676d6d2f61746f6d2d657869737464622f6d61737465722f62617369632e676966)