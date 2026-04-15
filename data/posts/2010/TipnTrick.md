---
title: "Tip n Trick: upload and validate XML"
date: 2010-12-01
author: "Dannes Wessels"
tags:
  - "community"
status: published
migrated-from: AtomicWiki
original-id: "TipnTrick"
original-blog: "dizzzz"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/dizzzz/TipnTrick"
---

I needed to be able to validate an XML document while the document should not be stored in the eXist-db database. The following code snipped shows how to do this

declare namespace util = "http://exist-db.org/xquery/util"; declare namespace validation = "http://exist-db.org/xquery/validation"; (: get file as base64 data from request object :) let $upload := request:get-uploaded-file-data("upload") (: convert base64 to string :) let $text := util:binary-to-string($upload) (: parse into node :) let $parsed := util:parse($text) (: validate :) let $report := validation:jaxv-report($parsed , xs:anyURI('/db/myschema.xsd'))