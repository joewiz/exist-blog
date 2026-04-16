xquery version "3.1";

(:~
 : XML sitemap generation for SEO.
 : Produces a sitemap at /blog/sitemap.xml
 :)
module namespace sitemap="http://exist-db.org/apps/blog/sitemap";

import module namespace config="http://exist-db.org/apps/blog/config" at "config.xqm";
import module namespace blog="http://exist-db.org/apps/blog" at "blog.xqm";
import module namespace feed="http://exist-db.org/apps/blog/feed" at "feed.xqm";

declare namespace smap="http://www.sitemaps.org/schemas/sitemap/0.9";

(:~
 : Generate an XML sitemap listing all published blog posts.
 :)
declare function sitemap:generate() as element(smap:urlset) {
    let $posts := blog:list-posts(map { "start": 1, "count": 999999 })
    let $base-url := feed:absolute-url($config:blog-base)
    return
        <smap:urlset>
            <!-- Blog index -->
            <smap:url>
                <smap:loc>{ $base-url }</smap:loc>
                <smap:changefreq>daily</smap:changefreq>
                <smap:priority>1.0</smap:priority>
            </smap:url>
            {
                for $post in $posts
                let $url := feed:absolute-url(blog:post-url($post?slug))
                let $date := $post?date
                return
                    <smap:url>
                        <smap:loc>{ $url }</smap:loc>
                        { if ($date) then <smap:lastmod>{ $date }</smap:lastmod> else () }
                        <smap:changefreq>monthly</smap:changefreq>
                        <smap:priority>0.8</smap:priority>
                    </smap:url>
            }
            {
                (: Tag pages :)
                for $tag-info in blog:get-tags()
                let $url := feed:absolute-url($config:blog-base || "/tag/" || $tag-info?tag)
                return
                    <smap:url>
                        <smap:loc>{ $url }</smap:loc>
                        <smap:changefreq>weekly</smap:changefreq>
                        <smap:priority>0.5</smap:priority>
                    </smap:url>
            }
        </smap:urlset>
};
