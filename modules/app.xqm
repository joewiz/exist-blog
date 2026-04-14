xquery version "3.1";

(:~
 : Template functions called from html-templating data-template attributes.
 : These populate the Jinks templates with blog data.
 :
 : Because html-templating's lib:attr/lib:value require specific parameter
 : conventions, we render complex HTML structures directly in these functions
 : rather than using nested data-template attributes.
 :)
module namespace app="http://exist-db.org/apps/blog/app";

import module namespace templates="http://exist-db.org/xquery/html-templating";
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
        if ($tag) then map { "tag": $tag } else (),
        if ($year) then map { "year": $year } else (),
        if ($month) then map { "month": $month } else ()
    )))
    let $total-pages := xs:integer(ceiling($total div $config:posts-per-page))
    return
        map {
            "posts": $posts,
            "current-page": $page,
            "total-pages": $total-pages,
            "total-posts": $total,
            "tag": $tag,
            "year": $year,
            "month": $month
        }
};

(:~
 : Render post summary cards with pagination.
 :)
declare function app:post-summaries($node as node(), $model as map(*)) {
    let $posts := $model?posts
    let $page := $model?current-page
    let $total-pages := $model?total-pages
    return
        <div class="post-list">{
        if (empty($posts)) then
            <p class="no-posts">No posts found.</p>
        else
            for $post in $posts
            return
                <article class="post-summary">
                    <h2 class="post-title">
                        <a href="{blog:post-url($post?slug)}">
                            {($post?title, "Untitled")[1]}
                        </a>
                    </h2>
                    <div class="post-meta">
                        <time>{$post?date}</time>
                        <span class="post-author">
                            by {$post?author}
                        </span>
                    </div>
                    {
                        if ($post?summary and $post?summary ne "") then
                            <p class="post-excerpt">{$post?summary}</p>
                        else ()
                    }
                    { app:render-tags($post?tags) }
                </article>,

        (: Pagination :)
        if ($total-pages le 1) then ()
        else
            let $base :=
                if ($model?tag) then
                    $config:blog-base || "/tag/" || $model?tag
                else
                    $config:blog-base
            return
                <nav class="pagination" aria-label="Blog pagination">
                    {
                        if ($page gt 1) then
                            <a href="{$base}/page/{$page - 1}" class="pagination-prev" rel="prev">Newer posts</a>
                        else ()
                    }
                    <span class="pagination-info">Page {$page} of {$total-pages}</span>
                    {
                        if ($page lt $total-pages) then
                            <a href="{$base}/page/{$page + 1}" class="pagination-next" rel="next">Older posts</a>
                        else ()
                    }
                </nav>
        }</div>
};

(:~
 : Render a tag list as inline links.
 :)
declare function app:render-tags($tags as array(*)) as element()? {
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
 : Render the tag cloud in the sidebar.
 :)
declare function app:tag-cloud($node as node(), $model as map(*)) {
    let $tags := blog:get-tags()
    return
        if (empty($tags)) then
            <p>No tags yet.</p>
        else
            <ul class="tag-cloud">{
                for $tag-info in $tags
                return
                    <li>
                        <a href="{$config:blog-base}/tag/{$tag-info?tag}">
                            {$tag-info?tag} ({$tag-info?count})
                        </a>
                    </li>
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
 : Render the full post content (header + body).
 :)
declare function app:post-content($node as node(), $model as map(*)) {
    let $post := $model?post
    let $_ :=
        if ($post?has-cells) then
            request:set-attribute("blog:has-cells", true())
        else ()
    return
        if (empty($post)) then
            <div class="error">
                <h1>Post Not Found</h1>
                <p>{$model?error}</p>
            </div>
        else
            <article class="post-detail">
                <header class="post-header">
                    <h1 class="post-title">{($post?title, "Untitled")[1]}</h1>
                    <div class="post-meta">
                        <time>{$post?date}</time>
                        <span class="post-author">by {$post?author}</span>
                        {
                            let $user := (
                                request:get-attribute($config:login-domain || ".user"),
                                sm:id()//sm:real/sm:username/string()
                            )[1]
                            return
                                if (exists($user) and $user ne "guest" and (sm:is-dba($user) or "blog-editor" = sm:get-user-groups($user))) then
                                    <a href="{$config:blog-base}/admin/editor/{$post?slug}" class="edit-link">Edit</a>
                                else ()
                        }
                    </div>
                    { app:render-tags($post?tags) }
                </header>
                <div class="post-body">{
                    if (exists($post?html)) then
                        $post?html
                    else if (exists($post?body)) then
                        blog:render-markdown($post?body)?html
                    else
                        <p>No content available.</p>
                }</div>
            </article>
};

(:~
 : Render the tag filter header.
 :)
declare function app:tag-header($node as node(), $model as map(*)) {
    let $tag := $model?tag
    return (
        <h1>Posts tagged: {$tag}</h1>,
        <p><a href="{$config:blog-base}/">View all posts</a>
        | <a href="{$config:blog-base}/tag/{$tag}/feed.xml">Atom feed for this tag</a></p>
    )
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
 : Render the archive page header.
 :)
declare function app:archive-header($node as node(), $model as map(*)) {
    let $label :=
        if ($model?filter-year and $model?filter-month) then
            "Archive: " || $model?filter-year || "-" || $model?filter-month
        else if ($model?filter-year) then
            "Archive: " || $model?filter-year
        else
            "Archive"
    return (
        <h1>{$label}</h1>,
        <p><a href="{$config:blog-base}/">Back to blog</a></p>
    )
};

(:~
 : Render the archive month navigation sidebar.
 :)
declare function app:archive-nav($node as node(), $model as map(*)) {
    let $groups := $model?archive-groups
    return
        if (empty($groups)) then
            <p>No archive data.</p>
        else
            <ul class="archive-months">{
                for $g in $groups
                return
                    <li>
                        <a href="{$config:blog-base}/{$g?year}/{$g?month}">
                            {$g?label} ({$g?count})
                        </a>
                    </li>
            }</ul>
};

(:~
 : Check if the current user is an editor (for admin template sections).
 :)
declare function app:if-editor($node as node(), $model as map(*)) {
    let $user := (
        request:get-attribute($config:login-domain || ".user"),
        sm:id()//sm:real/sm:username/string()
    )[1]
    return
        if (exists($user) and $user ne "guest" and (sm:is-dba($user) or "blog-editor" = sm:get-user-groups($user))) then
            templates:process($node/node(), $model)
        else
            ()
};

(:~
 : Show admin toolbar (Admin link) for editors on the landing page.
 :)
declare function app:admin-toolbar($node as node(), $model as map(*)) {
    let $user := (
        request:get-attribute($config:login-domain || ".user"),
        sm:id()//sm:real/sm:username/string()
    )[1]
    return
        if (exists($user) and $user ne "guest" and (sm:is-dba($user) or "blog-editor" = sm:get-user-groups($user))) then
            <nav class="admin-toolbar">
                <a href="{$config:blog-base}/admin" class="btn btn-small">Admin</a>
                <a href="{$config:blog-base}/admin/editor" class="btn btn-small btn-primary">New Post</a>
                <a href="{$config:blog-base}/logout" class="btn btn-small btn-secondary">Log Out</a>
            </nav>
        else ()
};

(:~
 : Generate an absolute link using $config:blog-base.
 : Usage: <a data-template="app:admin-link" data-template-href="admin/editor">text</a>
 :)
declare function app:admin-link($node as node(), $model as map(*), $href as xs:string) {
    element { node-name($node) } {
        $node/@* except $node/@href,
        attribute href { $config:blog-base || "/" || $href },
        $node/node()
    }
};

(:~
 : Inject admin JS scripts with absolute paths.
 :)
declare function app:admin-scripts($node as node(), $model as map(*)) {
    <script data-base="{$config:blog-base}" type="module" src="{$config:blog-base}/resources/js/admin.js"></script>
};

(:~
 : Inject editor JS scripts with absolute paths.
 :)
declare function app:editor-scripts($node as node(), $model as map(*)) {
    <script data-base="{$config:blog-base}" type="module" src="{$config:blog-base}/resources/js/editor.js"></script>
};
