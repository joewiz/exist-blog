xquery version "3.1";

(:~
 : XML sitemap generation for SEO.
 : Produces a sitemap at /blog/sitemap.xml
 :)
module namespace sitemap="http://exist-db.org/apps/blog/sitemap";

import module namespace config="http://exist-db.org/apps/blog/config" at "config.xqm";
import module namespace blog="http://exist-db.org/apps/blog" at "blog.xqm";
import module namespace feed="http://exist-db.org/apps/blog/feed" at "feed.xqm";

declare namespace sm="http://www.sitemaps.org/schemas/sitemap/0.9";

(:~
 : Generate an XML sitemap listing all published blog posts.
 :)
declare function sitemap:generate() as element(sm:urlset) {
    let $posts := blog:list-posts(map { "start": 1, "count": 999999 })
    let $base-url := feed:absolute-url($config:blog-base)
    return
        <sm:urlset>
            <!-- Blog index -->
            <sm:url>
                <sm:loc>{ $base-url || "/" }</sm:loc>
                <sm:changefreq>daily</sm:changefreq>
                <sm:priority>1.0</sm:priority>
            </sm:url>
            {
                for $post in $posts
                let $url := feed:absolute-url(blog:post-url($post?slug))
                let $date := $post?date
                return
                    <sm:url>
                        <sm:loc>{ $url }</sm:loc>
                        { if ($date) then <sm:lastmod>{ $date }</sm:lastmod> else () }
                        <sm:changefreq>monthly</sm:changefreq>
                        <sm:priority>0.8</sm:priority>
                    </sm:url>
            }
            {
                (: Tag pages :)
                for $tag-info in blog:get-tags()
                let $url := feed:absolute-url($config:blog-base || "/tag/" || $tag-info?tag)
                return
                    <sm:url>
                        <sm:loc>{ $url }</sm:loc>
                        <sm:changefreq>weekly</sm:changefreq>
                        <sm:priority>0.5</sm:priority>
                    </sm:url>
            }
        </sm:urlset>
};
