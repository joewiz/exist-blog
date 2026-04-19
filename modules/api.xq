xquery version "3.1";

(:~
 : API entry point for the blog.
 : Routes are defined in api.json (OpenAPI spec) and dispatched
 : to functions in admin.xqm, feed.xqm, etc.
 :)

declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";

import module namespace router="http://exist-db.org/api/router" at "router.xqm";
import module namespace admin="http://exist-db.org/apps/blog/admin" at "admin.xqm";
import module namespace blog="http://exist-db.org/apps/blog" at "blog.xqm";
import module namespace feed="http://exist-db.org/apps/blog/feed" at "feed.xqm";
import module namespace sitemap="http://exist-db.org/apps/blog/sitemap" at "sitemap.xqm";
import module namespace migrate="http://exist-db.org/apps/blog/migrate" at "migrate.xqm";

router:route(
    "modules/api.json",
    function($name as xs:string) {
        function-lookup(xs:QName($name), 1)
    }
)
