xquery version "3.1";

(:~
 : Migration module: converts AtomicWiki content to Markdown blog posts.
 :
 : AtomicWiki stores entries as Atom XML files (*.atom) with separate content
 : files (*.html or *.md). This module reads those entries from
 : /db/apps/wiki/data/ and converts them to Markdown files with YAML front matter
 : in the blog's data/posts/ collection.
 :
 : Content types handled:
 :   - "markdown" (wiki:editor = "markdown") — content is already .md, copy with new front matter
 :   - "html" (wiki:editor = "html") — convert HTML to Markdown (best-effort)
 :   - Other types — flag for manual review
 :
 : Invoked via: POST /api/migrate (DBA only)
 :)
module namespace migrate="http://exist-db.org/apps/blog/migrate";

import module namespace config="http://exist-db.org/apps/blog/config" at "config.xqm";
import module namespace blog="http://exist-db.org/apps/blog" at "blog.xqm";

declare namespace atom="http://www.w3.org/2005/Atom";
declare namespace wiki="http://exist-db.org/xquery/wiki";

(:~ Root collection of the old AtomicWiki data :)
declare variable $migrate:wiki-root := "/db/apps/wiki/data";

(:~
 : API entry point: run the migration.
 : Restricted to DBA users.
 :)
declare function migrate:run($request as map(*)) {
    let $user := request:get-attribute("org.exist.login.user")
    return
        if (empty($user) or not(sm:is-dba($user))) then
            map { "error": "Forbidden — DBA access required", "status": 403 }
        else if (not(xmldb:collection-available($migrate:wiki-root))) then
            map { "error": "AtomicWiki data not found at " || $migrate:wiki-root, "status": 404 }
        else
            let $entries := migrate:find-all-entries()
            let $results :=
                for $entry in $entries
                return migrate:convert-entry($entry)
            let $migrated := $results[?status eq "migrated"]
            let $skipped := $results[?status eq "skipped"]
            let $review := $results[?status eq "needs-review"]
            let $errors := $results[?status eq "error"]
            return map {
                "total": count($results),
                "migrated": count($migrated),
                "skipped": count($skipped),
                "needs-review": count($review),
                "errors": count($errors),
                "details": array { $results }
            }
};

(:~
 : Find all atom:entry elements across the wiki data collections.
 :)
declare function migrate:find-all-entries() as element(atom:entry)* {
    collection($migrate:wiki-root)//atom:entry
};

(:~
 : Convert a single AtomicWiki entry to a Markdown blog post.
 :)
declare function migrate:convert-entry($entry as element(atom:entry)) as map(*) {
    let $title := $entry/atom:title/string()
    let $wiki-id := $entry/wiki:id/string()
    let $published := $entry/atom:published/string()
    let $updated := $entry/atom:updated/string()
    let $author := ($entry/atom:author/atom:name/string(), "Unknown")[1]
    let $editor-type := ($entry/wiki:editor/string(), "html")[1]
    let $category := $entry/atom:category/@term/string()
    let $content-ref := $entry/atom:content
    let $content-type := ($content-ref/@type/string(), "html")[1]
    let $content-src := $content-ref/@src/string()
    let $entry-collection := util:collection-name($entry)

    (: Determine the date for the filename and front matter :)
    let $date :=
        if ($published) then
            substring($published, 1, 10)
        else if ($updated) then
            substring($updated, 1, 10)
        else
            "2012-01-01"
    let $year := substring($date, 1, 4)

    (: Generate a slug from the wiki ID or title :)
    let $slug :=
        if ($wiki-id and $wiki-id ne "") then
            blog:slugify($wiki-id)
        else
            blog:slugify(($title, "untitled")[1])

    return
        try {
            (: Load content :)
            let $content-body := migrate:load-content($entry-collection, $content-src, $content-type)

            (: Convert to Markdown if needed :)
            let $markdown :=
                if ($content-type eq "markdown" or $editor-type eq "markdown") then
                    (: Already Markdown — use as-is :)
                    map { "body": $content-body, "review": false() }
                else if ($content-type eq "html" or $editor-type eq "html") then
                    (: Convert HTML to Markdown — best effort :)
                    map { "body": migrate:html-to-markdown($content-body), "review": true() }
                else
                    (: Unknown type — flag for review :)
                    map { "body": $content-body, "review": true() }

            (: Build front matter :)
            let $tags :=
                if ($category) then "[" || $category || "]"
                else "[]"
            let $review-note :=
                if ($markdown?review) then
                    "&#10;# NOTE: This post was auto-migrated from AtomicWiki and may need manual review.&#10;&#10;"
                else
                    ""
            let $front-matter := string-join((
                "---",
                'title: "' || replace($title, '"', '\\"') || '"',
                "date: " || $date,
                "author: " || $author,
                "tags: " || $tags,
                if ($category) then "category: " || $category else (),
                "status: published",
                "migrated-from: AtomicWiki",
                "original-id: " || ($wiki-id, "unknown")[1],
                "---"
            ), "&#10;")

            let $full-markdown := $front-matter || "&#10;&#10;" || $review-note || $markdown?body

            (: Store the post :)
            let $target-collection := $config:posts-root || "/archive/" || $year
            let $filename := $slug || ".md"
            let $target-path := $target-collection || "/" || $filename

            return
                if (util:binary-doc-available($target-path)) then
                    map {
                        "status": "skipped",
                        "slug": "archive/" || $year || "/" || $slug,
                        "reason": "Already exists"
                    }
                else (
                    (: Ensure collection exists :)
                    if (xmldb:collection-available($target-collection)) then ()
                    else (
                        if (not(xmldb:collection-available($config:posts-root || "/archive"))) then
                            xmldb:create-collection($config:posts-root, "archive")
                        else (),
                        xmldb:create-collection($config:posts-root || "/archive", $year)
                    ),

                    xmldb:store($target-collection, $filename, $full-markdown, "text/markdown"),

                    map {
                        "status": if ($markdown?review) then "needs-review" else "migrated",
                        "slug": "archive/" || $year || "/" || $slug,
                        "title": $title,
                        "original-type": $content-type
                    }
                )
        } catch * {
            map {
                "status": "error",
                "title": $title,
                "wiki-id": $wiki-id,
                "error": $err:description
            }
        }
};

(:~
 : Load content from either an external file reference or inline content.
 :)
declare function migrate:load-content($collection as xs:string, $src as xs:string?,
    $content-type as xs:string) as xs:string {
    if ($src and $src ne "") then
        let $path := $collection || "/" || $src
        return
            if (util:binary-doc-available($path)) then
                util:binary-to-string(util:binary-doc($path))
            else if (doc-available($path)) then
                serialize(doc($path)/*)
            else
                "(Content file not found: " || $src || ")"
    else
        "(No content source specified)"
};

(:~
 : Best-effort HTML-to-Markdown conversion.
 : Handles common elements; complex HTML is preserved with a review flag.
 :)
declare function migrate:html-to-markdown($html as xs:string) as xs:string {
    let $cleaned := $html

    (: Headers :)
    let $cleaned := replace($cleaned, "<h1[^>]*>(.*?)</h1>", "# $1&#10;&#10;")
    let $cleaned := replace($cleaned, "<h2[^>]*>(.*?)</h2>", "## $1&#10;&#10;")
    let $cleaned := replace($cleaned, "<h3[^>]*>(.*?)</h3>", "### $1&#10;&#10;")
    let $cleaned := replace($cleaned, "<h4[^>]*>(.*?)</h4>", "#### $1&#10;&#10;")

    (: Paragraphs :)
    let $cleaned := replace($cleaned, "<p[^>]*>(.*?)</p>", "$1&#10;&#10;")

    (: Bold and italic :)
    let $cleaned := replace($cleaned, "<strong[^>]*>(.*?)</strong>", "**$1**")
    let $cleaned := replace($cleaned, "<b[^>]*>(.*?)</b>", "**$1**")
    let $cleaned := replace($cleaned, "<em[^>]*>(.*?)</em>", "*$1*")
    let $cleaned := replace($cleaned, "<i[^>]*>(.*?)</i>", "*$1*")

    (: Code :)
    let $cleaned := replace($cleaned, "<code[^>]*>(.*?)</code>", "`$1`")
    let $cleaned := replace($cleaned, "<pre[^>]*>(.*?)</pre>", "```&#10;$1&#10;```&#10;&#10;")

    (: Links :)
    let $cleaned := replace($cleaned, '<a[^>]*href="([^"]*)"[^>]*>(.*?)</a>', "[$2]($1)")

    (: Images :)
    let $cleaned := replace($cleaned, '<img[^>]*src="([^"]*)"[^>]*alt="([^"]*)"[^>]*/?>',
        "![$2]($1)")

    (: Lists :)
    let $cleaned := replace($cleaned, "<li[^>]*>(.*?)</li>", "- $1&#10;")
    let $cleaned := replace($cleaned, "</?[uo]l[^>]*>", "&#10;")

    (: Line breaks :)
    let $cleaned := replace($cleaned, "<br\s*/?>", "&#10;")

    (: Blockquotes :)
    let $cleaned := replace($cleaned, "<blockquote[^>]*>(.*?)</blockquote>", "> $1&#10;&#10;")

    (: Strip remaining HTML tags :)
    let $cleaned := replace($cleaned, "<[^>]+>", "")

    (: Clean up excessive whitespace :)
    let $cleaned := replace($cleaned, "&#10;{3,}", "&#10;&#10;")

    return normalize-space($cleaned)
};
