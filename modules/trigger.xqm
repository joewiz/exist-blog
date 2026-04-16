xquery version "3.1";

(:~
 : XQuery trigger for blog post indexing.
 :
 : When a Markdown post is stored in data/posts, this trigger converts it
 : to an XML document in data/posts-index so Lucene can index it.
 : The XML shadow document carries site-* fields for sitewide search.
 :)
module namespace trigger = "http://exist-db.org/xquery/trigger";

import module namespace config = "http://exist-db.org/apps/blog/config" at "config.xqm";
import module namespace blog   = "http://exist-db.org/apps/blog"         at "blog.xqm";

declare namespace xmldb = "http://exist-db.org/xquery/xmldb";

(:~ Index collection where XML shadow documents are stored. :)
declare variable $trigger:index-root := $config:app-root || "/data/posts-index";

(:~
 : Build an XML shadow document for a Markdown post.
 :)
declare %private function trigger:build-xml($uri as xs:string) as element()? {
    if (not(ends-with($uri, ".md"))) then ()
    else if (not(starts-with($uri, $config:posts-root))) then ()
    else if (not(util:binary-doc-available(xs:anyURI($uri)))) then ()
    else
        let $source  := util:binary-to-string(util:binary-doc(xs:anyURI($uri)))
        let $rel     := substring-after($uri, $config:posts-root || "/")
        let $slug    := replace($rel, "\.md$", "")
        let $meta    := blog:parse-front-matter($source)
        let $context :=
            try { request:get-context-path() }
            catch * { "/exist" }
        let $url     := $context || "/apps/blog/" || $slug
        return
            <post>
                <title>{$meta?title}</title>
                <author>{$meta?author}</author>
                <summary>{$meta?summary}</summary>
                <body>{$meta?body}</body>
                <date>{$meta?date}</date>
                <tags>{string-join($meta?tags?*, " ")}</tags>
                <slug>{$slug}</slug>
                <url>{$url}</url>
            </post>
};

(:~
 : Map a post URI to its shadow document filename in posts-index.
 : Flattens sub-path by replacing "/" with "-": 2026/03-post → 2026-03-post.xml
 :)
declare %private function trigger:shadow-name($uri as xs:string) as xs:string {
    let $rel  := substring-after($uri, $config:posts-root || "/")
    let $slug := replace($rel, "\.md$", "")
    return replace($slug, "/", "-") || ".xml"
};

(:~
 : Create or update the shadow document for a post.
 :)
declare %private function trigger:store-shadow($uri as xs:string) {
    let $xml := trigger:build-xml($uri)
    return
        if (exists($xml)) then
            let $filename := trigger:shadow-name($uri)
            return xmldb:store($trigger:index-root, $filename, $xml)
        else ()
};

(:~
 : Remove the shadow document for a deleted post.
 :)
declare %private function trigger:remove-shadow($uri as xs:string) {
    if (ends-with($uri, ".md") and starts-with($uri, $config:posts-root)) then
        let $filename := trigger:shadow-name($uri)
        let $full     := $trigger:index-root || "/" || $filename
        return
            if (doc-available($full)) then
                xmldb:remove($trigger:index-root, $filename)
            else ()
    else ()
};

(: === Trigger callbacks === :)

declare function trigger:after-create-document($uri as xs:anyURI) {
    trigger:store-shadow(xs:string($uri))
};

declare function trigger:after-update-document($uri as xs:anyURI) {
    trigger:store-shadow(xs:string($uri))
};

declare function trigger:after-delete-document($uri as xs:anyURI) {
    trigger:remove-shadow(xs:string($uri))
};
