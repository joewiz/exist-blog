---
title: "Eclipse Plugin for eXist"
date: 2008-09-08
author: wolf
tags: []
status: published
migrated-from: AtomicWiki
original-id: EclipsePlugin
original-url: https://exist-db.org/exist/apps/wiki/blogs/eXist/EclipsePlugin
---


# NOTE: This post was auto-migrated from AtomicWiki and may need manual review.

So far the following core functionalities are provided by the plugin: - Multiple Connections: In the *Browse View* you can administrate your eXist-connections. You're able to have several open connections at the same time, so that you can browse through the data of more than just one database. - Collection and Document Administration: You're able to add, remove or alter collections and documents. By double-clicking one of the collections, you'll get displayed the documents that are located in the collection. The documents can be opened with your preferred editor via context menu. - Queries: By right-clicking one of the collections, the entry *Run Query* let's you open the *Query View*. In there you can run a query for the according collection. The following picture illustrates the mentioned functionalities: The plugin can be installed as follows: - In the Eclipse menu you can open a wizard via *Help - Software Updates...* where you can administrate Add-ons. - Add the Update-Site of the eXist Eclipse plugin: []() - Mark the new entry and click on the "Install..." button. - You will be guided through the installation process.