xquery version "3.1";

(:~
 : Admin module for blog post CRUD operations.
 : Access restricted to DBA or blog-editor group members.
 :)
module namespace admin="http://exist-db.org/apps/blog/admin";

import module namespace config="http://exist-db.org/apps/blog/config" at "config.xqm";
import module namespace blog="http://exist-db.org/apps/blog" at "blog.xqm";
import module namespace router="http://e-editiones.org/roaster/router";

declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";

(:~
 : Check if the current user has blog admin permissions.
 :)
declare function admin:is-editor() as xs:boolean {
    let $user := (
        request:get-attribute($config:login-domain || ".user"),
        sm:id()//sm:real/sm:username/string()
    )[1]
    return
        exists($user) and $user ne "guest" and (
            sm:is-dba($user) or
            "blog-editor" = sm:get-user-groups($user)
        )
};

(:~
 : API: List all posts (including drafts) for admin management.
 :
 : %rest:GET
 : %rest:path("/api/posts")
 : %rest:produces("application/json")
 :)
declare function admin:list-posts($request as map(*)) {
    if (not(admin:is-editor())) then
        router:response(403, "application/json", map { "error": "Forbidden" }, ())
    else
        let $status := ($request?parameters?status, "all")[1]
        let $posts := blog:list-posts(map { "status": $status, "start": 1, "count": 999999 })
        return
            map {
                "posts": array {
                    for $post in $posts
                    return map {
                        "slug": $post?slug,
                        "title": ($post?title, "Untitled")[1],
                        "date": $post?date,
                        "author": $post?author,
                        "status": ($post?status, "published")[1],
                        "tags": $post?tags,
                        "category": $post?category,
                        "path": $post?path
                    }
                }
            }
};

(:~
 : API: Get a single post's raw Markdown source for editing.
 :
 : %rest:GET
 : %rest:path("/api/posts/{slug}")
 : %rest:produces("application/json")
 :)
declare function admin:get-post($request as map(*)) {
    if (not(admin:is-editor())) then
        router:response(403, "application/json", map { "error": "Forbidden" }, ())
    else
        let $slug := $request?parameters?slug
        let $path := $slug || ".md"
        let $full-path := $config:posts-root || "/" || $path
        return
            if (util:binary-doc-available($full-path)) then
                let $source := util:binary-to-string(util:binary-doc($full-path))
                let $meta := blog:parse-front-matter($source)
                return map {
                    "slug": $slug,
                    "source": $source,
                    "title": $meta?title,
                    "date": $meta?date,
                    "author": $meta?author,
                    "tags": $meta?tags,
                    "category": $meta?category,
                    "summary": $meta?summary,
                    "status": $meta?status,
                    "body": $meta?body
                }
            else
                router:response(404, "application/json", map { "error": "Post not found" }, ())
};

(:~
 : API: Create a new blog post.
 :
 : %rest:POST
 : %rest:path("/api/posts")
 : %rest:consumes("application/json")
 : %rest:produces("application/json")
 :)
declare function admin:create-post($request as map(*)) {
    if (not(admin:is-editor())) then
        router:response(403, "application/json", map { "error": "Forbidden" }, ())
    else
        let $body := $request?body
        let $title := $body?title
        let $date := ($body?date, format-date(current-date(), "[Y0001]-[M01]-[D01]"))[1]
        let $author := ($body?author, request:get-attribute($config:login-domain || ".user"))[1]
        let $tags := $body?tags
        let $category := $body?category
        let $summary := $body?summary
        let $status := ($body?status, "draft")[1]
        let $content := ($body?content, "")[1]
        let $slug := ($body?slug, blog:slugify($title))[1]
        let $year := substring($date, 1, 4)
        let $filename := $slug || ".md"
        let $collection := $config:posts-root || "/" || $year

        (: Build front matter :)
        let $tags-str :=
            if (exists($tags) and array:size($tags) gt 0) then
                "[" || string-join(for $i in 1 to array:size($tags) return array:get($tags, $i), ", ") || "]"
            else
                "[]"
        let $front-matter := string-join((
            "---",
            'title: "' || $title || '"',
            "date: " || $date,
            "author: " || $author,
            "tags: " || $tags-str,
            if ($category and $category ne "") then "category: " || $category else (),
            if ($summary and $summary ne "") then 'summary: "' || $summary || '"' else (),
            "status: " || $status,
            "---"
        ), "&#10;")

        let $markdown := $front-matter || "&#10;&#10;" || $content
        let $target-path := $collection || "/" || $filename

        return
            if (util:binary-doc-available($target-path)) then
                router:response(409, "application/json", map { "error": "Post already exists at " || $year || "/" || $slug }, ())
            else
                let $_ := (
                    if (xmldb:collection-available($collection)) then ()
                    else xmldb:create-collection($config:posts-root, $year),
                    xmldb:store($collection, $filename, $markdown, "text/markdown")
                )
                return map {
                    "success": true(),
                    "slug": $year || "/" || $slug,
                    "path": $year || "/" || $filename
                }
};

(:~
 : API: Update an existing blog post.
 :
 : %rest:PUT
 : %rest:path("/api/posts/{slug}")
 : %rest:consumes("application/json")
 : %rest:produces("application/json")
 :)
declare function admin:update-post($request as map(*)) {
    if (not(admin:is-editor())) then
        router:response(403, "application/json", map { "error": "Forbidden" }, ())
    else
        let $slug := $request?parameters?slug
        let $body := $request?body
        let $source := $body?source
        return
            if (empty($source) or $source eq "") then
                router:response(400, "application/json", map { "error": "No source content provided" }, ())
            else
                (: Find the file by slug — try with year prefix patterns :)
                let $path := admin:resolve-slug($slug)
                return
                    if (empty($path)) then
                        router:response(404, "application/json", map { "error": "Post not found: " || $slug }, ())
                    else
                        let $collection := replace($path, "/[^/]+$", "")
                        let $filename := replace($path, "^.*/", "")
                        let $_ := xmldb:store($collection, $filename, $source, "text/markdown")
                        return map { "success": true(), "slug": $slug }
};

(:~
 : API: Delete a blog post.
 :
 : %rest:DELETE
 : %rest:path("/api/posts/{slug}")
 : %rest:produces("application/json")
 :)
declare function admin:delete-post($request as map(*)) {
    if (not(admin:is-editor())) then
        router:response(403, "application/json", map { "error": "Forbidden" }, ())
    else
        let $slug := $request?parameters?slug
        let $path := admin:resolve-slug($slug)
        return
            if (empty($path)) then
                router:response(404, "application/json", map { "error": "Post not found: " || $slug }, ())
            else
                let $collection := replace($path, "/[^/]+$", "")
                let $filename := replace($path, "^.*/", "")
                let $_ := xmldb:remove($collection, $filename)
                return map { "success": true(), "deleted": $slug }
};

(:~
 : API: Upload an image for a blog post.
 :
 : %rest:POST
 : %rest:path("/api/images")
 : %rest:consumes("multipart/form-data")
 : %rest:produces("application/json")
 :)
declare function admin:upload-image($request as map(*)) {
    if (not(admin:is-editor())) then
        router:response(403, "application/json", map { "error": "Forbidden" }, ())
    else
        let $filename := $request?parameters?filename
        let $data := $request?body
        let $images-collection := $config:app-root || "/resources/images/posts"
        return
            let $_ :=
                if (not(xmldb:collection-available($images-collection))) then
                    xmldb:create-collection($config:app-root || "/resources/images", "posts")
                else ()
            let $_ := xmldb:store($images-collection, $filename, $data)
            return map {
                "success": true(),
                "url": $config:blog-base || "/resources/images/posts/" || $filename
            }
};

(:~
 : Resolve a slug like "2026/03-exist-7-preview" to a full database path.
 :)
declare function admin:resolve-slug($slug as xs:string) as xs:string? {
    let $path := $config:posts-root || "/" || $slug || ".md"
    return
        if (util:binary-doc-available($path)) then
            $path
        else
            (: Search all year collections for this slug :)
            let $filename := tokenize($slug, "/")[last()] || ".md"
            return
                (for $resource in blog:find-markdown-files($config:posts-root)
                 where ends-with($resource, "/" || $filename)
                 return $resource)[1]
};
