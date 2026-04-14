---
title: "Fast and easy JSON output: using the new JSON serializer"
date: 2011-03-27
author: "wolf"
tags: []
status: published
migrated-from: AtomicWiki
original-id: "JSONSerializer"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/JSONSerializer"
---

<div>

The new serializer is available in both, SVN trunk and the 1.4.x branch (which is the basis for the forthcoming 1.4.1 release), though the example below will only work on trunk (due to missing jquery libraries in 1.4.1). Using the serializer is as simple as adding a serialization declaration to the top of an XQuery:

``` xquery
declare option exist:serialize "method=json media-type=text/javascript";
```

This makes it easy to switch between XML and JSON output without changing the XQuery code. You can first develop the query until it produces the expected XML, then change the serialization method to JSON to interface with the client.

## Rules

There's more than one way to transform an XML document into JSON. eXist applies the following rules when converting XML to JSON:

1.  the root element will be absorbed, i.e.

    ``` xml
    <root>A</root>
    ```

    becomes "A"

2.  attributes are serialized as properties with the attribute name and its value

3.  an element with a single text child becomes a property with the value of the text child, i.e.

    ``` xml
    <e>text</e>
    ```

    becomes {"e": "text"}

4.  sibling elements with the same name within a parent element are added to an array. For example:

    ``` xml
    <book>
        <author>John Doe</author>
        <author>Robert Smith</author>
    </book>
    ```

    will be serialized as

    <div>

    { "author" : \["John Doe", "Robert Smith"\] }

    </div>

5.  in mixed content nodes, text nodes will be dropped.

6.  if an element has attribute and text content, the text content becomes a property, e.g. '#text': 'my text'

7.  an empty element becomes 'null', i.e.

    ``` xml
    <e/>
    ```

    becomes {"e": null}

8.  an element with name "[]()" is serialized as a simple value, not an object, i.e.

    ``` xml
    <json:value>value</json:value>
    ```

    just becomes "value"

Sometimes it is necessary to ensure that a certain property is serialized as an array, even if there's just one corresponding element in the XML input. The attribute []()`"true|false"` can be used for this.

By default, all values are strings. If you want to output a literal value, e.g. to serialize a number, use attribute []()`"true"`.

## Working Example

Let's have a look at some of the serialization features by using a real example: assume that we need to display the current database collection hierarchy in a web page. We would like to use the [dynatree](http://code.google.com/p/dynatree/) jQuery widget to present the collections as a tree. Dynatree has an option to load the tree to be displayed via an AJAX call and expects the server to return the tree data in JSON notation. The returned data should be an array of items. Each tree item may have children, which are contained in the property *children* as an array.

The following XQuery produces the required output:

``` xquery
xquery version "1.0";

declare namespace json="http://www.json.org";
declare option exist:serialize "method=json media-type=text/javascript";

declare function local:sub-collections($root as xs:string, $children as xs:string*) {
    for $child in $children
    return
        <children json:array="true">
        { local:collections(concat($root, '/', $child), $child) }
    </children>
};

declare function local:collections($root as xs:string, $label as xs:string) {
    let $children := xmldb:get-child-collections($root)
    return (
        <title>{$label}</title>,
        <isFolder json:literal="true">true</isFolder>,
        <key>{$root}</key>,
        if (exists($children)) then
            local:sub-collections($root, $children)
        else
            ()
    )
};

let $collection := request:get-parameter("root", "/db")
return
    <collection json:array="true">
    {local:collections($collection, replace($collection, "^.*/([^/]+$)", "$1"))}
    </collection>
```

We can now create an HTML file to embed the dynatree widget:

``` XML
<html>
    <head>
        <title>JSON Demo</title>
        <script type="text/javascript" src="libs/scripts/jquery/jquery-1.4.2.min.js"></script>
        <script type="text/javascript" src="libs/scripts/jquery/jquery-ui-1.8.custom.min.js"></script>
        <script type="text/javascript" src="libs/scripts/jquery/jquery.dynatree.min.js"></script>
        <link rel="stylesheet" type="text/css" href="libs/scripts/jquery/skin/ui.dynatree.css"/>
        <script type="text/javascript">
            $(document).ready(function() {
                $('#collection-tree').dynatree({
                    persist: false,
                    rootVisible: false,
                    initAjax: {url: "json.xql" },
                    clickFolderMode: 1,
                    onPostInit: function(isReloading, isError) {
                        var dbNode = this.getNodeByKey("/db");
                        dbNode.activate();
                        dbNode.expand(true);
                    }
                });
            });
        </script>
    </head>
    <body>
        <h1>JSON Serialization Demo</h1>
        <div id="collection-tree"/>
    </body>
</html>
```

The complete example is contained in directory `webapp/xquery/json` within your eXist installation (SVN trunk only). View the example by browsing to

<http://localhost:8080/exist/xquery/json/>

To better understand how the serialization works, I would also suggest to look at the test cases available in file `test/src/xquery/json.xml` in your eXist directory or [SVN](http://exist.svn.sourceforge.net/viewvc/exist/trunk/eXist/test/src/xquery/json.xml?revision=13759&#x26;view=markup).

</div>
