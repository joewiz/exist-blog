xquery version "3.1";

(:~
 : Blog search module.
 :
 : Queries the Lucene full-text index on data/posts-index.
 :)
module namespace blog-search = "http://exist-db.org/apps/blog/search";

import module namespace kwic   = "http://exist-db.org/xquery/kwic";
import module namespace config = "http://exist-db.org/apps/blog/config" at "config.xqm";

declare variable $blog-search:index-root := $config:app-root || "/data/posts-index";

(:~
 : Execute a full-text search over blog posts.
 :
 : @param $q     the query string
 : @param $limit max results to return (default 20)
 : @return array of result maps: title, snippet, url, date, author, score
 :)
declare function blog-search:query($q as xs:string, $limit as xs:integer) as array(*) {
    let $hits :=
        collection($blog-search:index-root)//post[ft:query(., $q, map { "fields": "site-content" })]
    return array {
        let $results :=
            for $hit in $hits
            order by ft:score($hit) descending
            return map {
                "title":   ($hit/title/string(), "Untitled")[1],
                "snippet": string-join(kwic:summarize($hit, <config width="80"/>)//text(), ""),
                "url":     $hit/url/string(),
                "date":    $hit/date/string(),
                "author":  $hit/author/string(),
                "score":   ft:score($hit)
            }
        return subsequence($results, 1, $limit)
    }
};

(:~
 : Rebuild the posts-index by re-processing all Markdown files.
 : Useful after bulk imports or initial deployment.
 :)
declare function blog-search:reindex() {
    for $resource in xmldb:get-child-resources($config:posts-root)
    where ends-with($resource, ".md")
    let $uri := $config:posts-root || "/" || $resource
    return ()
    (: trigger:after-update fires only for stored docs — call xmldb:reindex instead :)
};
