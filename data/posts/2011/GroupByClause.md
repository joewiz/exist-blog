---
title: "Group By Clause"
date: 2011-03-13
author: "Leif-Jöran Olsson"
tags:
  - "howto"
status: published
migrated-from: AtomicWiki
original-id: "GroupByClause"
original-blog: "HowTo"
original-url: "https://exist-db.org/exist/apps/wiki/HowTo/GroupByClause"
---

To make the awareness of the longtime addition of the Group by Clause supplied by Boris Verhaegen already in November 2006 to eXist-db bigger, I give you Boris's short but clean example of its use. This posting is the first step in order to close bug \#3165906 about documenting this feature.

let $g-b-data := &lt;items&gt; &lt;item&gt; &lt;key1&gt;1&lt;/key1&gt; &lt;key2&gt;a&lt;/key2&gt; &lt;/item&gt; &lt;item&gt; &lt;key1&gt;1&lt;/key1&gt; &lt;key2&gt;b&lt;/key2&gt; &lt;/item&gt; &lt;item&gt; &lt;key1&gt;0&lt;/key1&gt; &lt;key2&gt;c&lt;/key2&gt; &lt;/item&gt; &lt;item&gt; &lt;key1&gt;0&lt;/key1&gt; &lt;key2&gt;d&lt;/key2&gt; &lt;/item&gt; &lt;/items&gt; (: grouping query :) return for $item in $g-b-data//item group $item as $partition by $item/key1 as $key1 return &lt;group&gt; {$key1,$partition} &lt;/group&gt;

Which gives the following result:

&lt;group&gt; &lt;key1&gt;1&lt;/key1&gt; &lt;item&gt; &lt;key1&gt;1&lt;/key1&gt; &lt;key2&gt;a&lt;/key2&gt; &lt;/item&gt; &lt;item&gt; &lt;key1&gt;1&lt;/key1&gt; &lt;key2&gt;b&lt;/key2&gt; &lt;/item&gt; &lt;/group&gt; &lt;group&gt; &lt;key1&gt;0&lt;/key1&gt; &lt;item&gt; &lt;key1&gt;0&lt;/key1&gt; &lt;key2&gt;c&lt;/key2&gt; &lt;/item&gt; &lt;item&gt; &lt;key1&gt;0&lt;/key1&gt; &lt;key2&gt;d&lt;/key2&gt; &lt;/item&gt; &lt;/group&gt;