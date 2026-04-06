xquery version "3.1";

(:~
 : XQSuite tests for the blog module.
 :)
module namespace bt="http://exist-db.org/apps/blog/test";

import module namespace blog="http://exist-db.org/apps/blog" at "../../modules/blog.xqm";

declare namespace test="http://exist-db.org/xquery/xqsuite";

(:~
 : Test YAML front matter parsing with all fields.
 :)
declare
    %test:assertEquals("eXist-db 7.0 Preview", "2026-03-26", "Joe Wicentowski", "published")
function bt:parse-front-matter-full() {
    let $md := '---
title: "eXist-db 7.0 Preview"
date: 2026-03-26
author: Joe Wicentowski
tags: [release, xquery-4]
category: releases
summary: "A preview of 7.0"
status: published
---

# Content here'
    let $meta := blog:parse-front-matter($md)
    return (
        $meta?title,
        $meta?date,
        $meta?author,
        $meta?status
    )
};

(:~
 : Test front matter parsing extracts tags as an array.
 :)
declare
    %test:assertEquals(2)
function bt:parse-front-matter-tags() {
    let $md := '---
title: "Test"
tags: [release, xquery-4]
---

Body'
    let $meta := blog:parse-front-matter($md)
    return array:size($meta?tags)
};

(:~
 : Test that body content is correctly separated from front matter.
 :)
declare
    %test:assertTrue
function bt:parse-front-matter-body() {
    let $md := '---
title: "Test Post"
---

# Hello World

Some content.'
    let $meta := blog:parse-front-matter($md)
    return contains($meta?body, "Hello World")
};

(:~
 : Test parsing when no front matter is present.
 :)
declare
    %test:assertEquals("")
function bt:parse-no-front-matter() {
    let $md := "# Just a heading

Some content without front matter."
    let $meta := blog:parse-front-matter($md)
    return $meta?title
};

(:~
 : Test that default status is "published" when not specified.
 :)
declare
    %test:assertEquals("published")
function bt:default-status() {
    let $md := '---
title: "No Status"
---

Body'
    let $meta := blog:parse-front-matter($md)
    return $meta?status
};

(:~
 : Test slug generation.
 :)
declare
    %test:assertEquals("exist-db-70-preview")
function bt:slugify() {
    blog:slugify("eXist-db 7.0 Preview!")
};

(:~
 : Test slug generation with special characters.
 :)
declare
    %test:assertEquals("hello-world")
function bt:slugify-special-chars() {
    blog:slugify("Hello, World!")
};

(:~
 : Test that tags parsing handles empty arrays.
 :)
declare
    %test:assertEquals(0)
function bt:parse-empty-tags() {
    let $md := '---
title: "No Tags"
tags: []
---

Body'
    let $meta := blog:parse-front-matter($md)
    return array:size($meta?tags)
};

(:~
 : Test parsing quoted values (double quotes).
 :)
declare
    %test:assertEquals("A title with: colons")
function bt:parse-quoted-title() {
    let $md := '---
title: "A title with: colons"
---

Body'
    let $meta := blog:parse-front-matter($md)
    return $meta?title
};
