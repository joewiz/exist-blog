xquery version "3.1";

(:~
 : Template view module for the blog.
 :
 : Pass 1: html-templating processes data-template attributes in content templates
 : Pass 2: Jinks renders page-content.tpl (extends profile's base-page.html)
 :
 : If the profile files are not present (base-page.html missing), falls back
 : to page-content-standalone.tpl.
 :)

import module namespace templates="http://exist-db.org/xquery/html-templating";
import module namespace tmpl="http://e-editiones.org/xquery/templates";
import module namespace config="http://exist-db.org/apps/blog/config" at "config.xqm";
import module namespace blog="http://exist-db.org/apps/blog" at "blog.xqm";
import module namespace app="http://exist-db.org/apps/blog/app" at "app.xqm";

declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "html5";
declare option output:media-type "text/html";
declare option output:indent "no";

(:~ Function lookup for html-templating dispatch :)
declare function local:lookup($func as xs:string, $arity as xs:integer) as function(*)? {
    function-lookup(xs:QName($func), $arity)
};

(:~ html-templating configuration :)
declare variable $local:templating-config := map {
    $templates:CONFIG_APP_ROOT : $config:app-root,
    $templates:CONFIG_USE_CLASS_SYNTAX : false(),
    $templates:CONFIG_FILTER_ATTRIBUTES : true(),
    $templates:CONFIG_STOP_ON_ERROR : true()
};

(:~ Is the profile's base template available? :)
declare variable $local:profile-available :=
    let $path := $config:app-root || "/templates/base-page.html"
    return util:binary-doc-available($path) or doc-available($path);

(:~
 : Load a resource as a string.
 :)
declare function local:load-resource($path as xs:string) as xs:string? {
    if (util:binary-doc-available($path)) then
        util:binary-to-string(util:binary-doc($path))
    else if (doc-available($path)) then
        serialize(doc($path))
    else
        ()
};

(:~
 : Resolver for Jinks templates.
 : Handles absolute /db/ paths (for module resolution) and relative paths.
 :)
declare function local:resolver($path as xs:string) as map(*)? {
    let $effectivePath :=
        if (starts-with($path, "/db/")) then $path
        else $config:app-root || "/" || $path
    let $content := local:load-resource($effectivePath)
    return
        if ($content) then
            map { "path": $effectivePath, "content": $content }
        else
            ()
};

(:~
 : Build the rendering context matching the exist-site profile interface.
 :)
(:~
 : Build breadcrumb array from request attributes.
 : Each entry: map { "title": string, "url": string? }
 : Last entry has no URL (current page).
 :)
declare function local:build-breadcrumb() as array(*) {
    let $ctx := request:get-context-path() || "/apps/blog"
    let $activeTab := (request:get-attribute("active-tab"), "posts")[1]
    let $postSlug := request:get-attribute("post-slug")
    let $tag := request:get-attribute("tag")
    let $year := request:get-attribute("year")
    let $month := request:get-attribute("month")
    let $pageTitle := request:get-attribute("page-title")
    return
        if (exists($postSlug)) then
            (: Post detail: Blog / Posts / {title} :)
            array {
                map { "title": "Blog", "url": $ctx || "/" },
                map { "title": "Posts", "url": $ctx || "/" },
                map { "title": ($pageTitle, $postSlug)[1] }
            }
        else if (exists($tag)) then
            (: Tag listing: Blog / Tags / {tag} :)
            array {
                map { "title": "Blog", "url": $ctx || "/" },
                map { "title": "Tags" },
                map { "title": replace($tag, "-", " ") }
            }
        else if (exists($month)) then
            (: Archive by month: Blog / Archive / {year} / {month} :)
            array {
                map { "title": "Blog", "url": $ctx || "/" },
                map { "title": "Archive", "url": $ctx || "/archive" },
                map { "title": $year, "url": $ctx || "/" || $year },
                map { "title": $month }
            }
        else if (exists($year)) then
            (: Archive by year: Blog / Archive / {year} :)
            array {
                map { "title": "Blog", "url": $ctx || "/" },
                map { "title": "Archive", "url": $ctx || "/archive" },
                map { "title": $year }
            }
        else if ($activeTab = "archive") then
            array {
                map { "title": "Blog", "url": $ctx || "/" },
                map { "title": "Archive" }
            }
        else if ($activeTab = "search") then
            array {
                map { "title": "Blog", "url": $ctx || "/" },
                map { "title": "Search" }
            }
        else if ($activeTab = "admin") then
            array {
                map { "title": "Blog", "url": $ctx || "/" },
                map { "title": "Admin" }
            }
        else
            (: Blog index :)
            array {
                map { "title": "Blog" }
            }
};

declare function local:build-context() as map(*) {
    let $contextPath := request:get-context-path() || "/apps/blog"
    let $pageTitle := request:get-attribute("page-title")
    let $has-cells := (request:get-attribute("blog:has-cells"), false())[1]
    let $activeTab := (request:get-attribute("active-tab"), "posts")[1]
    let $user := request:get-attribute("org.exist.login.user")
    let $is-admin := exists($user) and sm:is-dba($user)
    let $tabs := map:merge(
        for $tab in ("posts", "archive", "search", "admin")
        return map { $tab: if ($tab eq $activeTab) then "active" else "" }
    )
    return map {
        "context-path": $contextPath,
        "styles": array { "resources/css/exist-site.css", "resources/css/blog.css" },
        "has-cells": $has-cells,
        "site": map {
            "name": "eXist-db",
            "logo": "resources/images/exist-logo.svg"
        },
        "nav": map {
            "items": array {
                map { "abbrev": "dashboard", "title": "Dashboard" },
                map { "abbrev": "docs", "title": "Documentation" },
                map { "abbrev": "notebook", "title": "Notebook" },
                map { "abbrev": "blog", "title": "Blog" }
            }
        },
        "page-title": if ($pageTitle) then $pageTitle || " — " || $config:blog-title else $config:blog-title,
        "tabs": $tabs,
        "is-admin": if ($is-admin) then "true" else "",
        "breadcrumb": local:build-breadcrumb()
    }
};

(:~
 : Render a full page.
 : Pass 1: html-templating processes data-template attributes
 : Pass 2: Jinks renders page-content.tpl (extends base-page.html)
 :)
declare function local:render-page($content as item()*) {
    let $ctx := local:build-context()
    let $fullCtx := map:merge((
        $ctx,
        map { "blog-content": $content }
    ))
    let $tplName :=
        if ($local:profile-available) then "page-content.tpl"
        else "page-content-standalone.tpl"
    let $tpl := local:load-resource($config:app-root || "/templates/" || $tplName)
    return
        if ($tpl) then
            tmpl:process($tpl, $fullCtx, map {
                "resolver": local:resolver#1,
                "modules": map {
                    "http://exist-db.org/site/nav": map {
                        "prefix": "nav",
                        "at": "/db/apps/exist-site-shell/modules/nav.xqm"
                    },
                    "http://exist-db.org/site/shell-config": map {
                        "prefix": "site-config",
                        "at": "/db/apps/exist-site-shell/modules/site-config.xqm"
                    }
                }
            })
        else
            $content
};

(: === Main entry point === :)

let $template-path := request:get-attribute("template")
let $full-path := $config:app-root || "/" || $template-path

(: Pass 1: Load and process the content template through html-templating :)
let $raw := local:load-resource($full-path)
let $content :=
    if (exists($raw)) then
        let $parsed := parse-xml($raw)
        return templates:apply(
            $parsed,
            local:lookup#2,
            (),
            $local:templating-config
        )
    else
        <div class="error">Template not found: {$template-path}</div>

(: Pass 2: Wrap in page layout :)
return
    if (request:get-attribute("layout") eq "full") then
        local:render-page($content)
    else
        $content
