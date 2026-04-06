xquery version "3.1";

(:~
 : Core blog module: post loading, listing, pagination, tag/category filtering.
 :
 : Blog posts are Markdown files with YAML front matter stored in
 : $config:posts-root. Front matter is parsed to extract metadata
 : (title, date, author, tags, category, summary, status).
 :)
module namespace blog="http://exist-db.org/apps/blog";

import module namespace config="http://exist-db.org/apps/blog/config" at "config.xqm";

declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";

(:~
 : Parse YAML front matter from a Markdown string.
 : Returns a map with keys: title, date, author, tags, category, summary, status.
 : Front matter is delimited by --- lines at the start of the file.
 :)
declare function blog:parse-front-matter($markdown as xs:string) as map(*) {
    let $lines := tokenize($markdown, "\n")
    return
        if (not(matches($lines[1], "^---\s*$"))) then
            (: no front matter :)
            map {
                "title": "",
                "date": "",
                "author": "",
                "tags": [],
                "category": "",
                "summary": "",
                "status": "published",
                "body": $markdown
            }
        else
            let $end-idx :=
                (for $i in 2 to count($lines)
                 where matches($lines[$i], "^---\s*$")
                 return $i)[1]
            let $yaml-lines := subsequence($lines, 2, $end-idx - 2)
            let $body := string-join(subsequence($lines, $end-idx + 1), "&#10;")
            let $meta := blog:parse-yaml-lines($yaml-lines)
            return
                map:merge((
                    $meta,
                    map { "body": $body }
                ))
};

(:~
 : Parse simple YAML key: value lines into a map.
 : Handles: scalar values, bracket arrays [a, b, c], quoted strings.
 :)
declare function blog:parse-yaml-lines($lines as xs:string*) as map(*) {
    map:merge(
        for $line in $lines
        let $trimmed := normalize-space($line)
        where contains($trimmed, ":")
        let $key := normalize-space(substring-before($trimmed, ":"))
        let $raw-value := normalize-space(substring-after($trimmed, ":"))
        let $value :=
            (: strip surrounding quotes :)
            if (matches($raw-value, '^".*"$') or matches($raw-value, "^'.*'$")) then
                substring($raw-value, 2, string-length($raw-value) - 2)
            else
                $raw-value
        return
            if ($key eq "tags") then
                (: parse [tag1, tag2, tag3] array :)
                let $inner := replace($value, "^\[|\]$", "")
                let $tags :=
                    for $tag in tokenize($inner, ",")
                    return normalize-space($tag)
                return map { "tags": array { $tags } }
            else if ($key eq "status") then
                map { "status": ($value[. ne ""], "published")[1] }
            else
                map { $key: $value }
    )
};

(:~
 : Load a single post by its relative path (e.g., "2026/03-exist-7-preview.md").
 : Returns a map with all metadata plus rendered HTML body.
 :)
declare function blog:get-post($rel-path as xs:string) as map(*)? {
    let $full-path := $config:posts-root || "/" || $rel-path
    return
        if (util:binary-doc-available($full-path)) then
            let $source := util:binary-to-string(util:binary-doc($full-path))
            let $meta := blog:parse-front-matter($source)
            let $slug := replace(replace($rel-path, "\.md$", ""), "/", "/")
            return
                map:merge((
                    $meta,
                    map {
                        "path": $rel-path,
                        "slug": $slug,
                        "html": blog:render-markdown($meta?body)
                    }
                ))
        else
            ()
};

(:~
 : List all published posts, sorted by date descending.
 : Returns a sequence of maps.
 :)
declare function blog:list-posts() as map(*)* {
    blog:list-posts(map {})
};

(:~
 : List posts with filtering options.
 : $options keys: tag, category, year, month, status, start, count
 :)
declare function blog:list-posts($options as map(*)) as map(*)* {
    let $tag := $options?tag
    let $category := $options?category
    let $year := $options?year
    let $month := $options?month
    let $status := ($options?status, "published")[1]
    let $start := xs:integer(($options?start, 1)[1])
    let $count := xs:integer(($options?count, $config:posts-per-page)[1])

    let $all-posts :=
        for $resource in blog:find-markdown-files($config:posts-root)
        let $rel-path := substring-after($resource, $config:posts-root || "/")
        let $source := util:binary-to-string(util:binary-doc($resource))
        let $meta := blog:parse-front-matter($source)
        where $meta?status eq $status or ($status eq "all")
        where empty($tag) or $tag = (
            for $i in 1 to array:size($meta?tags)
            return array:get($meta?tags, $i)
        )
        where empty($category) or $meta?category eq $category
        where empty($year) or starts-with($meta?date, $year)
        where empty($month) or (
            starts-with($meta?date, $year || "-" || $month)
        )
        order by $meta?date descending
        return
            map:merge((
                $meta,
                map {
                    "path": $rel-path,
                    "slug": replace(replace($rel-path, "\.md$", ""), "/", "/")
                }
            ))

    return subsequence($all-posts, $start, $count)
};

(:~
 : Count total published posts (with optional filtering).
 :)
declare function blog:count-posts($options as map(*)) as xs:integer {
    count(blog:list-posts(map:merge(($options, map { "start": 1, "count": 999999 }))))
};

(:~
 : Get all unique tags across published posts with counts.
 : Returns a sequence of maps with "tag" and "count" keys.
 :)
declare function blog:get-tags() as map(*)* {
    let $all-posts := blog:list-posts(map { "start": 1, "count": 999999 })
    let $all-tags :=
        for $post in $all-posts
        for $i in 1 to array:size($post?tags)
        return array:get($post?tags, $i)
    for $tag in distinct-values($all-tags)
    let $count := count($all-tags[. eq $tag])
    order by $count descending
    return map { "tag": $tag, "count": $count }
};

(:~
 : Get archive data: posts grouped by year/month.
 : Returns a sequence of maps with "year", "month", "count" keys.
 :)
declare function blog:get-archive() as map(*)* {
    let $all-posts := blog:list-posts(map { "start": 1, "count": 999999 })
    let $year-months :=
        for $post in $all-posts
        where string-length($post?date) ge 7
        return substring($post?date, 1, 7)
    for $ym in distinct-values($year-months)
    let $count := count($year-months[. eq $ym])
    let $parts := tokenize($ym, "-")
    order by $ym descending
    return map {
        "year": $parts[1],
        "month": $parts[2],
        "label": $ym,
        "count": $count
    }
};

(:~
 : Recursively find all .md files in a collection.
 : Excludes the wiki-import directory (migration source data).
 :)
declare function blog:find-markdown-files($collection as xs:string) as xs:string* {
    (
        for $resource in xmldb:get-child-resources($collection)
        where ends-with($resource, ".md")
        return $collection || "/" || $resource,

        for $child in xmldb:get-child-collections($collection)
        where $child ne "wiki-import"
        return blog:find-markdown-files($collection || "/" || $child)
    )
};

(:~ Namespace URI for exist-markdown module :)
declare variable $blog:MD_NS := "http://exist-db.org/xquery/markdown";

(:~ Java class for dynamic import of exist-markdown :)
declare variable $blog:MD_CLASS := "java:org.exist.xquery.modules.markdown.MarkdownModule";

(:~
 : Render Markdown to HTML.
 : Uses exist-markdown-3.0.0 if available, otherwise falls back to basic rendering.
 :)
declare function blog:render-markdown($markdown as xs:string) as node()* {
    let $parse-fn := blog:md-function("parse", 1)
    let $html-fn := blog:md-function("to-html", 1)
    (: Normalize line endings :)
    let $normalized := replace($markdown, "\r\n?", "&#10;")
    (: Strip HTML block wrapper tags (div, section, etc.) so flexmark
       processes all content as Markdown. The wrappers are purely structural
       from old AtomicWiki layouts and not needed in the blog. :)
    let $normalized := replace($normalized, "<(?:/)?(?:div|section|article|body|aside|nav|footer|header)(?:\s[^>]*)?>[\s]*", "")
    return
        if (exists($parse-fn) and exists($html-fn)) then
            (: Run through exist-markdown (handles Markdown + inline HTML) :)
            let $rendered := $html-fn($parse-fn($normalized))
            (: exist-markdown entity-escapes HTML block tags — unescape them :)
            let $html-str := serialize($rendered)
            let $unescaped := blog:unescape-html-tags($html-str)
            return
                try { parse-xml-fragment($unescaped) }
                catch * { $rendered }
        else
            <div class="markdown-raw"><pre>{ $markdown }</pre></div>
};

(:~
 : Unescape common HTML block/inline tags that exist-markdown entity-escapes.
 : Converts &lt;div&gt; back to <div>, etc.
 :)
declare function blog:unescape-html-tags($html as xs:string) as xs:string {
    $html
    => replace("&amp;lt;", "&lt;")
    => replace("&amp;gt;", "&gt;")
    => replace("&amp;amp;", "&amp;")
};

(:~
 : Look up an exist-markdown function by local name and arity.
 : Dynamically imports the Java module to avoid a hard compile-time dependency.
 :)
declare function blog:md-function($local-name as xs:string, $arity as xs:integer) as function(*)? {
    try {
        util:import-module(xs:anyURI($blog:MD_NS), "md", xs:anyURI($blog:MD_CLASS)),
        function-lookup(QName($blog:MD_NS, $local-name), $arity)
    } catch * {
        ()
    }
};

declare function blog:md-parse($markdown as xs:string) as node() {
    let $fn := blog:md-function("parse", 1)
    return
        if (exists($fn)) then
            $fn($markdown)
        else
            error(xs:QName("blog:NO_MARKDOWN"), "exist-markdown module not available")
};

declare function blog:md-to-html($parsed as node()) as node()* {
    let $fn := blog:md-function("to-html", 1)
    return
        if (exists($fn)) then
            $fn($parsed)
        else
            error(xs:QName("blog:NO_MARKDOWN"), "exist-markdown module not available")
};

(:~
 : Generate a URL-safe slug from a title.
 :)
declare function blog:slugify($title as xs:string) as xs:string {
    let $lower := lower-case($title)
    let $cleaned := replace($lower, "[^a-z0-9\s-]", "")
    let $dashed := replace(normalize-space($cleaned), "\s+", "-")
    return $dashed
};

(:~
 : Build a post URL from its slug.
 :)
declare function blog:post-url($slug as xs:string) as xs:string {
    $config:blog-base || "/" || $slug
};
