---
title: "Some Module Issues"
date: 2008-11-28
author: dizzzz
tags: []
status: published
migrated-from: AtomicWiki
original-id: SomeModuleIssues
original-url: https://exist-db.org/exist/apps/wiki/blogs/dizzzz/SomeModuleIssues
---


# NOTE: This post was auto-migrated from AtomicWiki and may need manual review.

As most of you (should) know by know, eXist does support xquery modules. With this it is possible to efficiently re-use xquery code. A small xquery example: import module namespace mod1 = "urn:module1" at "module1.xqm"; &lt;a&gt; &lt;b&gt;{mod1:showMe()}&lt;/b&gt; &lt;/a&gt; and a not too complex module: module namespace mod1 = "urn:module1"; declare function mod1:showMe() as xs:string { "hi from module 1" }; In this example the module is located in the same collection as the query; This rather simple query-module relation works perfectly and is used in many applications. Things get more difficult when a module itself has a relation with one ore more modules. It turns out that modules are always resolved relative to the 'first executed' xquery. That means that if your module imports another module (e.g. module3.xqm in collection sub) special things happen: Layout: /db/query.xq /db/collection/module2.xqm /db/collection/sub/module3.xqm In this example query.xq imports module2.xqm and module2.xqm imports module3.xqm ; One would expect that the following code would be sufficient for module2.xqm: import module namespace mod3 = "urn:module3" at "sub/module3.xqm"; What actually happens is that the query engine tries to resolve module3.xqm from /db/sub/module3.xqm. The only solution to have the module loaded correctly, is to specify a full path in the database: import module namespace mod3 = "urn:module3" at "xmldb:///db/collection/sub/module3.xqm"; The bad thing about this construct is that it makes your application less portable/movable. I think this limitation does not make sense. I'll investigate this issue and 'll (try to) make a fix for it (unless Perig disagrees with the solution :-) )