xquery version "3.1";

(:~
 : URL routing for the blog application.
 :
 : Public routes:
 :   /                        → post listing (page 1)
 :   /page/{n}                → post listing page n
 :   /tag/{tag}               → posts filtered by tag
 :   /tag/{tag}/feed.xml      → per-tag Atom feed
 :   /{year}/{slug}           → single post (e.g., /2026/03-exist-7-preview)
 :   /{year}/{month}          → archive by year/month
 :   /{year}                  → archive by year
 :   /archive                 → full archive
 :   /feed.xml                → Atom feed
 :   /sitemap.xml             → XML sitemap
 :
 : Admin routes (DBA / blog-editor):
 :   /admin                   → admin post list
 :   /admin/editor             → new post editor
 :   /admin/editor/{slug}     → edit existing post
 :
 : API routes:
 :   /api/*                   → Roaster REST API
 :)

import module namespace login="http://exist-db.org/xquery/login"
    at "resource:org/exist/xquery/modules/persistentlogin/login.xql";
import module namespace blog="http://exist-db.org/apps/blog" at "modules/blog.xqm";
import module namespace feed="http://exist-db.org/apps/blog/feed" at "modules/feed.xqm";
import module namespace sitemap="http://exist-db.org/apps/blog/sitemap" at "modules/sitemap.xqm";

declare namespace atom="http://www.w3.org/2005/Atom";
declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";

declare variable $exist:path external;
declare variable $exist:resource external;
declare variable $exist:controller external;
declare variable $exist:prefix external;
declare variable $exist:root external;

declare variable $local:login-domain := "org.exist.login";

(: Process persistent login on every request :)
let $login := login:set-user($local:login-domain, xs:dayTimeDuration("P7D"), false())
let $user := request:get-attribute($local:login-domain || ".user")
let $method := lower-case(request:get-method())

return

(: --- Trailing-slash redirect --- :)
if ($exist:path eq '') then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="{request:get-uri()}/"/>
    </dispatch>

(: --- Atom feed --- :)
else if ($exist:path eq '/feed.xml') then (
    util:declare-option("exist:serialize", "method=xml media-type=application/atom+xml indent=yes"),
    feed:generate((), ())
)

(: --- Per-tag Atom feed: /tag/{tag}/feed.xml --- :)
else if (matches($exist:path, "^/tag/([^/]+)/feed\.xml$")) then
    let $tag := replace($exist:path, "^/tag/([^/]+)/feed\.xml$", "$1")
    return (
        util:declare-option("exist:serialize", "method=xml media-type=application/atom+xml indent=yes"),
        feed:generate($tag, ())
    )

(: --- XML sitemap --- :)
else if ($exist:path eq '/sitemap.xml') then (
    util:declare-option("exist:serialize", "method=xml media-type=application/xml indent=yes"),
    sitemap:generate()
)

(: --- API routes → Roaster --- :)
else if (starts-with($exist:path, "/api/")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/modules/api.xq">
            <set-header name="Access-Control-Allow-Origin" value="*"/>
            <set-header name="Cache-Control" value="no-cache"/>
        </forward>
    </dispatch>

(: --- Login (GET) --- :)
else if ($exist:resource eq "login" and $method eq "get") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/login.html"/>
    </dispatch>

(: --- Login (POST) --- :)
else if ($exist:resource eq "login" and $method eq "post") then
    let $base := request:get-context-path() || "/apps/blog"
    return
    if ($user and not($user = ("guest", "nobody"))) then
        <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
            <redirect url="{request:get-parameter('redirect', $base || '/admin')}"/>
        </dispatch>
    else
        <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
            <redirect url="{$base}/login?error=1"/>
        </dispatch>

(: --- Logout: clear persistent login cookie and session --- :)
else if ($exist:resource eq "logout") then (
    response:set-cookie($local:login-domain, "deleted", xs:dayTimeDuration("-P1D"), false(), (),
        request:get-context-path()),
    session:invalidate(),
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="{request:get-context-path()}/apps/blog/"/>
    </dispatch>
)

(: --- Admin: redirect to login if not authenticated --- :)
else if (starts-with($exist:path, '/admin') and (empty($user) or $user = ("guest", "nobody"))) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="{request:get-context-path()}/apps/blog/login?redirect={encode-for-uri(request:get-uri())}"/>
    </dispatch>

(: --- Admin: post management --- :)
else if ($exist:path eq '/admin' or $exist:path eq '/admin/') then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/modules/view.xq">
            <set-attribute name="template" value="templates/admin/post-list.tpl"/>
            <set-attribute name="layout" value="full"/>
            <set-attribute name="page-title" value="Admin"/>
        </forward>
    </dispatch>

(: --- Admin: editor (new or edit) --- :)
else if (matches($exist:path, "^/admin/editor")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/modules/view.xq">
            <set-attribute name="template" value="templates/admin/editor.tpl"/>
            <set-attribute name="layout" value="full"/>
            <set-attribute name="page-title" value="Editor"/>
        </forward>
    </dispatch>

(: --- Static resources --- :)
else if (matches($exist:path, "^/resources/")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}{$exist:path}">
            <set-header name="Cache-Control" value="max-age=3600, must-revalidate"/>
        </forward>
    </dispatch>

(: --- Tag listing: /tag/{tag} --- :)
else if (matches($exist:path, "^/tag/([^/]+)/?$")) then
    let $tag := replace($exist:path, "^/tag/([^/]+)/?$", "$1")
    return
        <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
            <forward url="{$exist:controller}/modules/view.xq">
                <set-attribute name="template" value="templates/tag-list.tpl"/>
                <set-attribute name="layout" value="full"/>
                <set-attribute name="tag" value="{$tag}"/>
                <set-attribute name="page-title" value="Tag: {$tag}"/>
            </forward>
        </dispatch>

(: --- Archive: /archive --- :)
else if ($exist:path eq '/archive' or $exist:path eq '/archive/') then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/modules/view.xq">
            <set-attribute name="template" value="templates/archive.tpl"/>
            <set-attribute name="layout" value="full"/>
            <set-attribute name="page-title" value="Archive"/>
        </forward>
    </dispatch>

(: --- Archive by year: /2026 --- :)
else if (matches($exist:path, "^/(\d{4})/?$")) then
    let $year := replace($exist:path, "^/(\d{4})/?$", "$1")
    return
        <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
            <forward url="{$exist:controller}/modules/view.xq">
                <set-attribute name="template" value="templates/archive.tpl"/>
                <set-attribute name="layout" value="full"/>
                <set-attribute name="year" value="{$year}"/>
                <set-attribute name="page-title" value="Archive: {$year}"/>
            </forward>
        </dispatch>

(: --- Archive by year/month: /2026/03 --- :)
else if (matches($exist:path, "^/(\d{4})/(\d{2})/?$")) then
    let $year := replace($exist:path, "^/(\d{4})/(\d{2})/?$", "$1")
    let $month := replace($exist:path, "^/(\d{4})/(\d{2})/?$", "$2")
    return
        <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
            <forward url="{$exist:controller}/modules/view.xq">
                <set-attribute name="template" value="templates/archive.tpl"/>
                <set-attribute name="layout" value="full"/>
                <set-attribute name="year" value="{$year}"/>
                <set-attribute name="month" value="{$month}"/>
                <set-attribute name="page-title" value="Archive: {$year}-{$month}"/>
            </forward>
        </dispatch>

(: --- Archived post: /archive/{year}/{slug} --- :)
else if (matches($exist:path, "^/archive/(\d{4})/([^/]+)$")) then
    let $year := replace($exist:path, "^/archive/(\d{4})/([^/]+)$", "$1")
    let $slug := replace($exist:path, "^/archive/(\d{4})/([^/]+)$", "$2")
    return
        <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
            <forward url="{$exist:controller}/modules/view.xq">
                <set-attribute name="template" value="templates/post-detail.tpl"/>
                <set-attribute name="layout" value="full"/>
                <set-attribute name="post-slug" value="archive/{$year}/{$slug}"/>
            </forward>
        </dispatch>

(: --- Single post: /{year}/{slug} --- :)
else if (matches($exist:path, "^/(\d{4})/([^/]+)$")) then
    let $year := replace($exist:path, "^/(\d{4})/([^/]+)$", "$1")
    let $slug := replace($exist:path, "^/(\d{4})/([^/]+)$", "$2")
    return
        <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
            <forward url="{$exist:controller}/modules/view.xq">
                <set-attribute name="template" value="templates/post-detail.tpl"/>
                <set-attribute name="layout" value="full"/>
                <set-attribute name="post-slug" value="{$year}/{$slug}"/>
            </forward>
        </dispatch>

(: --- Paginated listing: /page/{n} --- :)
else if (matches($exist:path, "^/page/(\d+)/?$")) then
    let $page := replace($exist:path, "^/page/(\d+)/?$", "$1")
    return
        <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
            <forward url="{$exist:controller}/modules/view.xq">
                <set-attribute name="template" value="templates/post-list.tpl"/>
                <set-attribute name="layout" value="full"/>
                <set-attribute name="page" value="{$page}"/>
                <set-attribute name="page-title" value="Page {$page}"/>
            </forward>
        </dispatch>

(: --- Blog index --- :)
else if ($exist:path eq '/' or $exist:path eq '') then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/modules/view.xq">
            <set-attribute name="template" value="templates/post-list.tpl"/>
            <set-attribute name="layout" value="full"/>
            <set-attribute name="page" value="1"/>
        </forward>
    </dispatch>

(: --- 404 --- :)
else (
    response:set-status-code(404),
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/modules/view.xq">
            <set-attribute name="template" value="templates/post-list.tpl"/>
            <set-attribute name="layout" value="full"/>
            <set-attribute name="page-title" value="Not Found"/>
        </forward>
    </dispatch>
)
