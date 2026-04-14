---
title: "Content Extraction and Binary Resource Indexing"
date: 2011-09-14
author: "admin"
tags: []
status: published
migrated-from: AtomicWiki
original-id: "ContentExtraction"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/ContentExtraction"
---

# Content Extraction

## Prerequisites

The content extraction module is based on Apache tika. Tika understands a large variety of formats, ranging from PDF documents to spreadsheets and image metadata. It thus requires a number of helper libraries, which will be installed automatically when you build the module.

To get started, you need a recent checkout of eXist from SVN trunk. Enable the content extraction module by editing `EXIST_HOME/extensions/build.properties` and set the corresponding property to true:

<div>

\# Binary Content and Metadata Extraction Module include.feature.contentextraction = true

</div>

Next, call `build.sh/build.bat` from eXist's top directory to build the module. You should see in the output how the various libraries are downloaded and installed.

## Usage

To import the module use an import statement as follows:

``` xquery
import module namespace content="http://exist-db.org/xquery/contentextraction"
at "java:org.exist.contentextraction.xquery.ContentExtractionModule";
```

The module provides three functions:

``` xquery
content:get-metadata($binary as xs:base64Binary) as document-node()
content:get-metadata-and-content($binary as xs:base64Binary) as document-node()
content:stream-content($binary as xs:base64Binary, $paths as xs:string*, $callback as function, $namespaces as element()?, $userData as item()*) as empty()
```

The first two functions don't need much of an explanation: `get-metadata` just returns some metadata extracted from the resource, while `get-metadata-and-content` will also provide the text body of the resource - if there is any. The third function is a streaming variant of the other two and is used to process larger resources, whose content may not fit into memory.

All functions produce XHTML. The metadata will be contained in the HTML head, the contents go into the body. The structure of the body HTML varies a lot, depending on the media type you parse. For PDFs, the body is just a sequence of divs, one for each page. One can use this feature to extract page numbers, as I do in my example application (see below). However, in most cases the HTML structure will be mostly flat.

# Indexing

While you could decide to just store the html returned by the content extraction functions as an XML resource into the database, this is not very efficient, in particular for larger documents. You would need to maintain both, the binary as well as the extracted html.

We have thus added a feature to the existing full text indexing module, which allows users to associate additional text indexes with a binary resource (or actually: any resource, binary or xml). The index will be linked to the resource, meaning that the same permissions apply and if the resource is deleted, the index will be removed as well.

To create an index, call the `index` function with the following arguments:

- The path of the resource to which the index should be linked as a string.
- An XML fragment describing the fields you want to add and the text content to index.

For example, to associate an index with the document test.txt one may call `index` as follows:

``` xquery
ft:index("/db/demo/test.txt",
  <doc>
    <field name="title" store="yes">Indexing</field>
    <field name="para" store="yes">This is the first paragraph.</field>
    <field name="para" store="yes">And a second paragraph.</field>
  </doc>)
```

This creates a lucene index document, indexes the content using the configured analyzers, and links it to the eXist document with the given path. You may link more than one lucene document to the same eXist resource.

The field elements map to lucene fields. You can use as many fields as you want or add multiple fields with the same name. The store="yes" attribute tells the indexer to also store the text string, so you can retrieve it later.

It ist also possible to configure the analyzers used by lucene for indexing a given feed as well as other options in the collection configuration.

To query the created index, use the `search` function:

``` xquery
ft:search("/db/demo/test.txt", "para:paragraph and title:indexing")
```

The first parameter is the path to the resource or collection to query, the second specifies a lucene query string. Note how we prefix the query term by the name of the field. Executing this query returns:

``` xml
<results>
  <search uri="/db/demo/test.txt" score="6.3111067">
    <field name="para">This is the first <exist:match>paragraph</exist:match>.</field>
    <field name="para">And a second <exist:match>paragraph</exist:match>.</field>
    <field name="title"><exist:match>Indexing</exist:match></field>
  </search>
</results>
```

Each matching resource is described by a search element. The score attribute expresses the relevance lucene computed for the resource (the higher the better). Within the search element, every field which contributed to the query result is returned, but only if store="yes" was defined for this field at indexing time (if not, the field content won't be available). Note how the matches in the text are enclosed in match elements, just as if you did a full text query on an XML document. This makes it easy to post-process the query result, for example to create a keywords in context display using eXist's standard kwic module.

The document the index is linked to does not need to be a binary resource. One can also create additional indexes on xml documents. This is a useful feature, because it allows us to index and query information which is not directly contained in the XML itself. For example, one could add metadata fields and retrieve them later using `get-field`. Or we could use fields to pre-process and normalize information already present in the XML to speed up later access.

# Combining content extraction and indexing

The following example extracts metadata and content from a PDF (I chose the TEI guidelines) and creates a field for each page. Please note that extracting content can take a while and is a memory intensive process. For larger PDFs, you want to use `stream-content`. We do not cover this here, but you may have a look at the sample application (see below).

``` xquery
xquery version "1.0";
declare namespace xhtml="http://www.w3.org/1999/xhtml";
import module namespace content="http://exist-db.org/xquery/contentextraction"
  at "java:org.exist.contentextraction.xquery.ContentExtractionModule";
let $path := "/db/Guidelines.pdf"
let $binary := util:binary-doc($path)
let $content := content:get-metadata-and-content($binary)
let $indexDef :=
  <doc>
    <field name="title" store="yes">{ $content//xhtml:title/text() }</field>
    {
      for $page in $content//xhtml:div[@class = "page"]/xhtml:p
      return
        <field name="page" store="yes">{ $page/text() }</field>
    }
  </doc>
return
  ft:index($path, $indexDef)
```

We can now query the index, using `summarize` to get just the immediate context of the match in the text:

``` xquery
xquery version "1.0";
import module namespace kwic="http://exist-db.org/xquery/kwic"
at "resource:org/exist/xquery/lib/kwic.xql";
for $result in ft:search("/db/Guidelines.pdf", 'page:"page layout"')/search
for $field in $result/field
return
  kwic:summarize($field, <config width="40"/>)
```

# Demo app

To see queries on binary documents in action and study a complete code example, please head over to my [sample application](http://demo.exist-db.org/exist/apps/demo/cex-demo.html). This application is available as an installable package, so you can play with the code locally.

To install the package into your own eXist instance watch our [screencast](/blogs/eXist/AppRepository) or follow the steps below:

- Open the admin page in the web application and log in as admin
- Select the "Package Repository" link from the sidebar
- Switch to the "Public Repo" tab and click on "Retrieve packages"
- You should see a list of packages available on the server
- Click on the package "eXist-db Demo Apps (0.1)"
- Click on the install icon
- After installation finished, the package should show up in the "Installed" tab
- Click the installed package. You should see a link "Local URL". Click it to get to the application
