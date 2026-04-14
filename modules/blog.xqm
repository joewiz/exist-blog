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
declare namespace md="http://exist-db.org/xquery/markdown";

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
 : Extract block-sequence items for a given key from YAML lines.
 : Collects "  - item" lines that immediately follow "key:" with no value.
 :)
declare function blog:yaml-block-seq($lines as xs:string*, $key as xs:string) as xs:string* {
    let $n := count($lines)
    let $key-pattern := "^" || $key || ":\s*$"
    let $key-idx :=
        (for $i in 1 to $n
         where matches(normalize-space($lines[$i]), $key-pattern)
         return $i)[1]
    return
        if (empty($key-idx)) then ()
        else
            let $next-key-idx :=
                (for $j in ($key-idx + 1) to $n
                 where matches(normalize-space($lines[$j]), "^[a-zA-Z][a-zA-Z_-]*:")
                 return $j)[1]
            let $end := ($next-key-idx - 1, $n)[1]
            for $j in ($key-idx + 1) to $end
            where matches($lines[$j], "^\s+-")
            return replace(normalize-space($lines[$j]), '^-\s*"?(.*?)"?\s*$', '$1')
};

(:~
 : Parse simple YAML key: value lines into a map.
 : Handles: scalar values, bracket arrays [a, b, c], quoted strings,
 : and multi-line block sequences (- item per line).
 :)
declare function blog:parse-yaml-lines($lines as xs:string*) as map(*) {
    let $block-tags := blog:yaml-block-seq($lines, "tags")
    let $scalar-map := map:merge(
        for $line in $lines
        let $trimmed := normalize-space($line)
        where contains($trimmed, ":") and not(matches($trimmed, "^-"))
        let $key := normalize-space(substring-before($trimmed, ":"))
        let $raw-value := normalize-space(substring-after($trimmed, ":"))
        let $value :=
            if (matches($raw-value, '^".*"$') or matches($raw-value, "^'.*'$")) then
                substring($raw-value, 2, string-length($raw-value) - 2)
            else
                $raw-value
        return
            if ($key eq "tags") then
                if ($raw-value ne "") then
                    (: inline array: tags: [a, b, c] :)
                    let $inner := replace($value, "^\[|\]$", "")
                    return map { "tags": array {
                        for $tag in tokenize($inner, ",") return normalize-space($tag)
                    } }
                else () (: block sequence — handled below :)
            else if ($key eq "status") then
                map { "status": ($value[. ne ""], "published")[1] }
            else
                map { $key: $value }
    )
    return
        if (exists($block-tags)) then
            map:merge(($scalar-map, map { "tags": array { $block-tags } }))
        else
            $scalar-map
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
            let $rendered := blog:render-markdown($meta?body)
            return
                map:merge((
                    $meta,
                    map {
                        "path": $rel-path,
                        "slug": $slug,
                        "html": $rendered?html,
                        "has-cells": $rendered?has-cells
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
 : Parse Pandoc-style fenced code options from a language string.
 : E.g. "xquery {method=json indent=yes}" → map { "method": "json", "indent": "yes" }
 :)
declare %private function blog:parse-cell-options($language as xs:string) as map(*) {
    let $attr-match := analyze-string($language, "\{([^}]*)\}")
    return
        if ($attr-match//fn:group[@nr="1"]) then
            let $attr-str := string($attr-match//fn:group[@nr="1"])
            let $pairs := analyze-string($attr-str, '(\S+?)=("[^"]*"|''[^'']*''|\S+)')
            return map:merge(
                for $match in $pairs//fn:match
                let $key := string($match/fn:group[@nr="1"])
                let $val := string($match/fn:group[@nr="2"])
                let $val := replace($val, '^["'']|["'']$', '')
                return map:entry($key, $val)
            )
        else
            map {}
};

(:~
 : Render an XQuery fenced code block as an interactive blog cell.
 :)
declare %private function blog:render-cell(
    $query as xs:string,
    $options as map(*)
) as element() {
    let $method := ($options?method, "adaptive")[1]
    return
    <div class="blog-cell"
            data-method="{$method}"
            data-indent="{($options?indent, '')[1]}">
        <div class="blog-cell-header">
            <span class="blog-cell-label">XQuery</span>
            {
                if (map:size($options) > 0) then
                    <span class="blog-cell-options">{
                        string-join(
                            for $key in map:keys($options)
                            return $key || "=" || $options($key),
                            " "
                        )
                    }</span>
                else ()
            }
        </div>
        <div class="blog-cell-editor">
            <jinn-codemirror mode="xquery" code="{$query}"></jinn-codemirror>
        </div>
        <div class="blog-cell-actions">
            <button class="blog-cell-run">Run &#x25b6;</button>
            <button class="blog-cell-reset" style="display:none">Reset &#x21ba;</button>
            <select class="blog-cell-method">
                <option value="adaptive">{if ($method eq "adaptive") then attribute selected {"selected"} else ()}Adaptive</option>
                <option value="xml">{if ($method eq "xml") then attribute selected {"selected"} else ()}XML</option>
                <option value="json">{if ($method eq "json") then attribute selected {"selected"} else ()}JSON</option>
                <option value="text">{if ($method eq "text") then attribute selected {"selected"} else ()}Text</option>
            </select>
        </div>
        <div class="blog-cell-result" style="display:none"></div>
    </div>
};

(:~
 : Render Markdown to HTML, converting xquery fenced code blocks to interactive cells.
 : Returns a map with "html" (node()*) and "has-cells" (xs:boolean).
 :)
declare function blog:render-markdown($markdown as xs:string) as map(*) {
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
            let $doc := $parse-fn($normalized)
            let $xquery-blocks := $doc//md:fenced-code[starts-with(@language, "xquery")]
            let $has-cells := exists($xquery-blocks)
            let $html :=
                for $node in $doc/md:document/*
                return
                    if ($node/self::md:fenced-code[starts-with(@language, "xquery")]) then
                        let $options := blog:parse-cell-options(string($node/@language))
                        return blog:render-cell(string($node), $options)
                    else
                        (: Run through exist-markdown and unescape entity-escaped HTML tags :)
                        let $partial := $html-fn($node)
                        let $str := blog:unescape-html-tags(serialize($partial))
                        return try { parse-xml-fragment($str) } catch * { $partial }
            return map { "html": $html, "has-cells": $has-cells }
        else
            map {
                "html": <div class="markdown-raw"><pre>{ $markdown }</pre></div>,
                "has-cells": false()
            }
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
 : Render Markdown to HTML nodes only (no cell detection).
 : Convenience wrapper returning just the html nodes for non-post contexts.
 :)
declare function blog:render-markdown-html($markdown as xs:string) as node()* {
    blog:render-markdown($markdown)?html
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
