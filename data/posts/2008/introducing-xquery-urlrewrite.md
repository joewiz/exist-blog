---
title: "Introducing XQueryURLRewrite"
date: 2008-12-08
author: "wolf"
tags: []
status: published
migrated-from: AtomicWiki
original-id: "IntroducingXQueryURLRewrite"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/IntroducingXQueryURLRewrite"
---

<div>

At the core of the new setup is a servlet filter: *XQueryURLRewrite*. I primarily created it to process URLs in AtomicWiki, but it eventually developed into kind of a simple, servlet-based model-view-controller framework.

XQueryURLRewrite was mainly inspired by the Java package [UrlRewriteFilter](http://tuckey.org/urlrewrite/) and a bit by Spring MVC. The main difference is that we are not using any configuration files to configure the URL rewriting: instead, the controller is a single XQuery, which is executed once for every request. The XQuery must return an XML fragment, which tells the servlet filter how to proceed with the request. For example, all paths in AtomicWiki map to a single XQuery. The user can directly access a wiki entry through a simple URL like `/blogs/eXist/EclipsePlugin` which internally translates to

    index.xql?feed=blogs/eXist/&ref=EclipsePlugin

The XQuery code for this mapping is shown below:

``` xquery
let $path := substring-after($uri, request:get-context-path())
let $params :=
    subsequence(text:groups($path, '^/?(.*)/([^/]+)$'), 2)
return
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="/index.xql">
            <add-parameter name="feed" value="{$params[1]}"/>
            <add-parameter name="ref" value="{$params[2]}"/>
        </forward>
    </dispatch>
```

The `forward` element tells XQueryURLRewrite to pass the request to the specified URL, which is always interpreted relative to the current request context (e.g. `/exist`). You could also forward to a servlet instead of an URL by specifying its name (`servlet="ServletName"`). The forwarding is done via the RequestDispatcher of the servlet engine and is thus invisible to the user. If you want the user to see the rewritten URL, you can replace the `forward` action with a `redirect`.

If no action is specified within the `dispatch` element, the request will just be passed through the filter chain and will be handled the normal way. The same happens if the action is an element `ignore`.

But even without an action, you can still post-process the HTTP response and send it through one or more "views". A "view" is nothing else but another dispatch action. It receives an HTTP POST request whose body is set to the output of the previous action (if there was any output at all, see below). For example, to display the eXist documentation, we send the XML document through a servlet to apply an XSL stylesheet:

``` xquery
if (ends-with($uri, '.xml')) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <view>
            <forward servlet="XSLTServlet">
                <set-attribute name="xslt.stylesheet" 
                    value="stylesheets/db2html.xsl"/>
            </forward>
        </view>
    </dispatch>
else
    (: ....... :)
```

This code snippet is taken from `EXIST_HOME/webapp/controller.xql`. You can look at the file to see it in context.

We can also pass a request through more than one "view". The following fragment applies two stylesheets in sequence:

<div>

if (\$name eq 'biblio.xql') then let \$display := request:get-parameter("display", "overview") let \$xsl := if (\$display eq "details") then "detailed.xsl" else "overview.xsl" return else (: ......... :)

</div>

The example also demonstrates how information can be passed between actions. XQueryServlet - which is called implicitely because the URL ends with ".xql" - sees the request attribute "xquery.attribute" set to "xslt.model". This causes the servlet to fill the request attribute "xslt.model" with the results of the XQuery it executes. The query result will not be written to the HTTP response as you would normally expect.

XSLTServlet receives the request attribute "xslt.input" which points to "xslt.model". It checks "xslt.model" and finds the query results which were passed from XQueryServlet. It thus discards the current request content (which is empty anyway) and uses the data in "xslt.model" as input for the transformation process. The result is then written to the HTTP response, which is served to the second XSLTServlet.

What benefits does it have to exchange data through request attributes? Well, we save one serialization step: XQueryServlet directly passes the node tree of its output as a valid XQuery value, so XSLTServlet doesn't need to parse it again. Using request attributes is even more useful if you have two or more XQueries which need to exchange information. XQuery 1 can use the XQuery function []() to save an arbitrary XQuery sequence. XQuery 2 then calls []() to retrieve this value.

A final note on performance: the controller XQuery will be called for every request, including those for images, CSS styles etc. This may generate a small overhead (though the controller query should usually be fast). You can use the `cache-control` element to specify that the request routing for the current URI should be cached. This way, the controller query is only evaluated once for the given URI.

</div>
