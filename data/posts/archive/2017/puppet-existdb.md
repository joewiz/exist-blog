---
title: "Puppet Module for eXist-db"
date: 2017-07-07
author: admin
tags: []
status: published
migrated-from: AtomicWiki
original-id: puppet-existdb
original-url: https://exist-db.org/exist/apps/wiki/blogs/eXist/puppet-existdb
---

# Puppet Module for eXist-db

[Jon Hallet](https://github.com/jonjhallettuob) of the [University of Bristol](http://bristol.ac.uk/), has very kindly contributed a Puppet module for eXist-db to the project. The work on the Puppet module was made possible by funding from the [AHRC](http://www.ahrc.ac.uk/) as part of the [Manuscript Pamphleteering in Early Stuart England](https://mpese.rit.bris.ac.uk/exist/apps/mpese/index.html) project.

[Puppet](https://puppet.com/community) is a [software configuration management](https://en.wikipedia.org/wiki/Puppet_%28software%29) tool which when combined with Jon's module, allows you to easily configure and deploy eXist-db to one (or more servers) with just a few commands. Puppet will also maintain the installation state, ensuring that any accidental changes by administrators are rolled-back to the configured state.

You can find the eXist-db Puppet module here: [https://github.com/eXist-db/puppet-existdb](https://github.com/eXist-db/puppet-existdb).

Many thanks to Jon and the University of Bristol :-)