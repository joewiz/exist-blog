xquery version "3.1";

(:~
 : Atom feed generation module.
 : Adapted from AtomicWiki's feeds.xql pattern, simplified for a Markdown blog.
 :
 : Generates:
 :   /blog/feed.xml         — full Atom feed of recent posts
 :   /blog/tag/{tag}/feed.xml — per-tag feed
 :)
module namespace feed="http://exist-db.org/apps/blog/feed";

import module namespace config="http://exist-db.org/apps/blog/config" at "config.xqm";
import module namespace blog="http://exist-db.org/apps/blog" at "blog.xqm";

declare namespace atom="http://www.w3.org/2005/Atom";

(:~
 : Generate an Atom feed for the blog.
 : @param $tag optional tag filter (empty string or () for all posts)
 : @param $count number of entries to include (default 20)
 :)
declare function feed:generate($tag as xs:string?, $count as xs:integer?) as element(atom:feed) {
    let $actual-count := ($count, 20)[1]
    let $options :=
        if ($tag and $tag ne "") then
            map { "tag": $tag, "start": 1, "count": $actual-count }
        else
            map { "start": 1, "count": $actual-count }
    let $posts := blog:list-posts($options)
    let $feed-title :=
        if ($tag and $tag ne "") then
            $config:blog-title || " — " || $tag
        else
            $config:blog-title
    let $blog-url := feed:absolute-url($config:blog-base || "/")
    let $feed-url :=
        if ($tag and $tag ne "") then
            feed:absolute-url($config:blog-base || "/tag/" || $tag || "/feed.xml")
        else
            feed:absolute-url($config:blog-base || "/feed.xml")
    let $latest-date :=
        if (exists($posts)) then
            ($posts[1])?date
        else
            format-date(current-date(), "[Y0001]-[M01]-[D01]")
    return
        <atom:feed>
            <atom:id>{ $feed-url }</atom:id>
            <atom:title>{ $feed-title }</atom:title>
            <atom:subtitle>{ $config:blog-tagline }</atom:subtitle>
            <atom:link href="{ $feed-url }" rel="self" type="application/atom+xml"/>
            <atom:link href="{ $blog-url }" rel="alternate" type="text/html"/>
            <atom:updated>{ $latest-date || "T00:00:00Z" }</atom:updated>
            <atom:author>
                <atom:name>{ $config:blog-author }</atom:name>
            </atom:author>
            <atom:generator uri="https://github.com/eXist-db/exist-blog" version="1.0.0">
                exist-blog
            </atom:generator>
            {
                for $post in $posts
                return feed:entry($post)
            }
        </atom:feed>
};

(:~
 : Generate a single Atom entry from a post map.
 :)
declare function feed:entry($post as map(*)) as element(atom:entry) {
    let $post-url := feed:absolute-url(blog:post-url($post?slug))
    let $date := ($post?date, format-date(current-date(), "[Y0001]-[M01]-[D01]"))[1]
    return
        <atom:entry>
            <atom:id>{ $post-url }</atom:id>
            <atom:title>{ ($post?title, "Untitled")[1] }</atom:title>
            <atom:link href="{ $post-url }" rel="alternate" type="text/html"/>
            <atom:published>{ $date || "T00:00:00Z" }</atom:published>
            <atom:updated>{ $date || "T00:00:00Z" }</atom:updated>
            <atom:author>
                <atom:name>{ ($post?author, $config:blog-author)[1] }</atom:name>
            </atom:author>
            {
                for $i in 1 to array:size($post?tags)
                let $tag := array:get($post?tags, $i)
                return <atom:category term="{ $tag }"/>
            }
            {
                if ($post?summary and $post?summary ne "") then
                    <atom:summary type="text">{ $post?summary }</atom:summary>
                else
                    ()
            }
            <atom:content type="html">{ serialize(blog:render-markdown($post?body)) }</atom:content>
        </atom:entry>
};

(:~
 : Convert a relative URL to an absolute URL using the current request.
 :)
declare function feed:absolute-url($path as xs:string) as xs:string {
    let $scheme := request:get-scheme()
    let $host := request:get-server-name()
    let $port := request:get-server-port()
    let $port-str :=
        if (($scheme eq "http" and $port eq 80) or ($scheme eq "https" and $port eq 443)) then
            ""
        else
            ":" || $port
    return
        $scheme || "://" || $host || $port-str || $path
};
