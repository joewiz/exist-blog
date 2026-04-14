---
title: "New Full Text Index is Based on Lucene"
date: 2008-10-24
author: "dizzzz"
tags: []
status: published
migrated-from: AtomicWiki
original-id: "LuceneIndexModule"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/LuceneIndexModule"
---

![](http://lucene.apache.org/images/lucene_green_300.gif)

There have been other attempts to combine eXist with Apache Lucene in the past. One of the advantages of our new approach is a tight integration into eXist's *modularized indexing architecture*: the index behaves like a plugin which adds itself to the db's *index pipelines*. Once configured, the index will be notified of all relevant events, like adding/removing a document, removing a collection or updating single nodes. No manual reindex is required to keep the index up to date. The module also implements common interfaces which are shared with other indexes, e.g. for highlighting matches. It is thus easy to switch between the lucene index and e.g. the ngram index without rewriting too much XQuery code.

Querying lucene from XQuery is straightforward. For example:

``` xquery
for $s in //SPEECH[ft:query(LINE, 'witch*')]
order by ft:score($s) descending
return $s
```

The `query` function takes a query string in Lucene's default query [syntax](http://lucene.apache.org/java/2_4_0/queryparsersyntax.html). It returns a set of nodes which are relevant with respect to the query. Lucene assigns a relevance score or rank to each match. This score is preserved by eXist and can be accessed through the `score` function, which returns a decimal value. The higher the score, the more relevant is the text.

The lucene module is fully supported by eXist's *query-rewriting optimizer*, which means that the query engine can rewrite the XQuery expression to make best use of the available indexes.

Using extension functions has the advantage that no changes are required to the XQuery parser. In a next step we might use the existing functionality as a basis to implement the W3C's "XQuery and XPath Full Text 1.0" recommendation.

## How does it work?

The main challenge for eXist is that it needs a way to map a match returned by Lucene back to the XML node which contains the text that triggered the match. Lucene deals with (text-) documents and fields, eXist with nodes. We thus create a Lucene document for every element or attribute which has an index defined on it, using the node's docId and nodeId as fields. In eXist, every XML node is identified by a unique, hierarchical id (which looks like e.g. 3.6.3.16.8/1). We use this id to make the connection between the node in eXist and the "document" indexed by Lucene.

## Enabling the Lucene Index

To experiment with the new index, you need to check out the development version of eXist from SVN trunk. Though using a dev version is never without risk, the current trunk should be quite stable and has been tested for a while.

Before building eXist, you need to enable the Lucene module by editing `extensions/indexes/build.properties` (also see the documentation on [index modules](http://www.exist-db.org/indexing.html#moduleconf)):

<div>

\# Lucene integration include.index.lucene = true

</div>

Then (re-)build eXist using the provided `build.sh` or `build.bat`. The build process downloads the required Lucene jars automatically. If everything builds ok, you should find a jar `exist-lucene-module.jar` in the `lib/extensions` directory. Next, edit the main configuration file, `conf.xml` and comment in the two lucene-related sections:

``` xml
<modules>
  <module id="lucene-index" class="org.exist.indexing.lucene.LuceneIndex"/>
  ...
</modules>
...
<builtin-modules>
  <module id="lucene-index" class="org.exist.indexing.lucene.LuceneIndex"/>
  ...
</builtin-modules>
```

## Index Configuration

Like other indexes, you create a lucene index by configuring it in a `collection.xconf` document. If you have never done that before, read the corresponding [documentation](http://www.exist-db.org/indexing.html#idxconf). An example `collection.xconf` is shown below:

``` xml
<collection xmlns="http://exist-db.org/collection-config/1.0">
    <index xmlns:atom="http://www.w3.org/2005/Atom"
        xmlns:html="http://www.w3.org/1999/xhtml"
        xmlns:wiki="http://exist-db.org/xquery/wiki">
    <!-- Disable the standard full text index -->
        <fulltext default="none" attributes="no"/>
    <!-- Lucene index is configured below -->
        <lucene>
        <analyzer class="org.apache.lucene.analysis.standard.StandardAnalyzer"/>
            <analyzer id="ws" class="org.apache.lucene.analysis.WhitespaceAnalyzer"/>
            <text match="//SPEECH//*"/>
        <text qname="TITLE" analyzer="ws"/>
        </lucene>
    </index>
</collection>
```

You can either define a lucene index on a single element or attribute name (qname="...") or a node path with wildcards (match="..."). Please note that the argument to `match` is a simple path pattern, not an XPath expression. It only allows / and // to denote a child or descendant step, plus the wildcard to match an arbitrary element.

    //SPEECH/*

will index all child elements of SPEECH, while

    //SPEECH//*

indexes all descendants.

Why can't we support full XPath syntax for the index configuration? Well, the query engine often needs to decide at compile time if an index can be used or not, which means that we have to limit the possible configuration choices.

One of the strengths of Lucene is that it allows the developer to determine nearly every aspect of the text analysis. This is mostly done through [analyzer classes](http://lucene.apache.org/java/2_4_0/api/core/org/apache/lucene/analysis/Analyzer.html), which combine a tokenizer with a chain of filters to post-process the tokenized text. As shown in the example above, eXist's lucene module does already allow different analyzers to be used for different indexes. We will certainly add more features in the future, e.g. a possibility to construct a new analyzer from a set of filters. For the time being, you can always provide your own analyzer or use one of those supplied by Lucene or compatible software.

## Plans

- allow lucene queries to be created programmatically. `query` should take an XML fragment which describes the query
- use different analyzers for different languages, e.g. by checking for an []() attribute
- allow new analyzers to be constructed in the collection configuration document
- implement the W3C's fulltext extensions for XQuery. The grammar for the extensions has already been merged into the XQuery parser as part of a Google Summer of Code project and is available in an SVN branch. It just needs to be filled with life.
