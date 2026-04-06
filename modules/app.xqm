xquery version "3.1";

(:~
 : Template functions called from html-templating data-template attributes.
 : These populate the Jinks templates with blog data.
 :)
module namespace app="http://exist-db.org/apps/blog/app";

import module namespace templates="http://exist-db.org/xquery/html-templating";
import module namespace lib="http://exist-db.org/xquery/html-templating/lib";
import module namespace config="http://exist-db.org/apps/blog/config" at "config.xqm";
import module namespace blog="http://exist-db.org/apps/blog" at "blog.xqm";

declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";

(:~
 : Load the post list for the current page and inject into the model.
 :)
declare
    %templates:wrap
function app:post-list($node as node(), $model as map(*)) {
    let $page := xs:integer((request:get-attribute("page"), request:get-parameter("page", "1"))[1])
    let $tag := (request:get-attribute("tag"), request:get-parameter("tag", ()))[1]
    let $year := (request:get-attribute("year"), request:get-parameter("year", ()))[1]
    let $month := (request:get-attribute("month"), request:get-parameter("month", ()))[1]
    let $start := ($page - 1) * $config:posts-per-page + 1
    let $options := map:merge((
        map { "start": $start, "count": $config:posts-per-page },
        if ($tag) then map { "tag": $tag } else (),
        if ($year) then map { "year": $year } else (),
        if ($month) then map { "month": $month } else ()
    ))
    let $posts := blog:list-posts($options)
    let $total := blog:count-posts(map:merge((
        $options,
        map { "start": 1, "count": 999999 }
    )))
    let $total-pages := ceiling($total div $config:posts-per-page)
    return
        map {
            "posts": $posts,
            "current-page": $page,
            "total-pages": $total-pages,
            "total-posts": $total,
            "has-prev": $page gt 1,
            "has-next": $page lt $total-pages,
            "tag": $tag,
            "year": $year,
            "month": $month
        }
};

(:~
 : Iterate over posts in the model.
 :)
declare
    %templates:wrap
function app:each-post($node as node(), $model as map(*)) {
    for $post in $model?posts
    return
        templates:process($node/node(), map:merge(($model, map { "post": $post })))
};

(:~
 : Output a post field value.
 :)
declare function app:post-field($node as node(), $model as map(*), $field as xs:string) {
    let $post := $model?post
    return
        switch ($field)
            case "title" return ($post?title, "Untitled")[1]
            case "date" return $post?date
            case "author" return $post?author
            case "summary" return $post?summary
            case "category" return $post?category
            case "slug" return $post?slug
            case "url" return blog:post-url($post?slug)
            case "status" return ($post?status, "published")[1]
            default return ""
};

(:~
 : Output post tags as a list of links.
 :)
declare function app:post-tags($node as node(), $model as map(*)) {
    let $post := $model?post
    let $tags := $post?tags
    return
        if (array:size($tags) eq 0) then ()
        else
            <ul class="post-tags">{
                for $i in 1 to array:size($tags)
                let $tag := array:get($tags, $i)
                return
                    <li><a href="{$config:blog-base}/tag/{$tag}">{$tag}</a></li>
            }</ul>
};

(:~
 : Load and render a single post detail, injecting into the model.
 :)
declare
    %templates:wrap
function app:post-detail($node as node(), $model as map(*)) {
    let $slug := (request:get-attribute("post-slug"), request:get-parameter("slug", ()))[1]
    return
        if (empty($slug)) then
            map { "error": "No post specified" }
        else
            let $post := blog:get-post($slug || ".md")
            return
                if (exists($post)) then
                    map { "post": $post }
                else
                    map { "error": "Post not found: " || $slug }
};

(:~
 : Output the rendered HTML body of a post.
 :)
declare function app:post-body($node as node(), $model as map(*)) {
    let $post := $model?post
    return
        if (exists($post?html)) then
            $post?html
        else if (exists($post?body)) then
            blog:render-markdown($post?body)
        else
            <p class="error">No content available.</p>
};

(:~
 : Output OpenGraph meta tags for a post.
 :)
declare function app:og-meta($node as node(), $model as map(*)) {
    let $post := $model?post
    return
        if (empty($post)) then ()
        else (
            <meta property="og:type" content="article"/>,
            <meta property="og:title" content="{($post?title, $config:blog-title)[1]}"/>,
            if ($post?summary) then
                <meta property="og:description" content="{$post?summary}"/>
            else (),
            <meta property="og:url" content="{blog:post-url($post?slug)}"/>,
            <meta property="article:published_time" content="{$post?date}"/>,
            <meta property="article:author" content="{$post?author}"/>
        )
};

(:~
 : Load tag list data.
 :)
declare
    %templates:wrap
function app:tag-list($node as node(), $model as map(*)) {
    map { "tags": blog:get-tags() }
};

(:~
 : Iterate over tags.
 :)
declare
    %templates:wrap
function app:each-tag($node as node(), $model as map(*)) {
    for $tag-info in $model?tags
    return
        templates:process($node/node(), map:merge(($model, map {
            "tag-name": $tag-info?tag,
            "tag-count": $tag-info?count,
            "tag-url": $config:blog-base || "/tag/" || $tag-info?tag
        })))
};

(:~
 : Load archive data.
 :)
declare
    %templates:wrap
function app:archive-list($node as node(), $model as map(*)) {
    let $year := (request:get-attribute("year"), request:get-parameter("year", ()))[1]
    let $month := (request:get-attribute("month"), request:get-parameter("month", ()))[1]
    let $options := map:merge((
        map { "start": 1, "count": 999999 },
        if ($year) then map { "year": $year } else (),
        if ($month) then map { "month": $month } else ()
    ))
    let $posts := blog:list-posts($options)
    return
        map {
            "posts": $posts,
            "archive-groups": blog:get-archive(),
            "filter-year": $year,
            "filter-month": $month
        }
};

(:~
 : Output pagination controls.
 :)
declare function app:pagination($node as node(), $model as map(*)) {
    let $page := $model?current-page
    let $total := $model?total-pages
    let $tag := $model?tag
    let $base :=
        if ($tag) then
            $config:blog-base || "/tag/" || $tag
        else
            $config:blog-base
    return
        if ($total le 1) then ()
        else
            <nav class="pagination" aria-label="Blog pagination">
                {
                    if ($page gt 1) then
                        <a href="{$base}/page/{$page - 1}" class="pagination-prev" rel="prev">Newer posts</a>
                    else ()
                }
                <span class="pagination-info">Page {$page} of {$total}</span>
                {
                    if ($page lt $total) then
                        <a href="{$base}/page/{$page + 1}" class="pagination-next" rel="next">Older posts</a>
                    else ()
                }
            </nav>
};

(:~
 : Check if the current user is an editor (for admin template sections).
 :)
declare function app:if-editor($node as node(), $model as map(*)) {
    let $user := request:get-attribute($config:login-domain || ".user")
    return
        if (exists($user) and (sm:is-dba($user) or "blog-editor" = sm:get-user-groups($user))) then
            templates:process($node/node(), $model)
        else
            ()
};
