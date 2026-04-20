xquery version "3.1";

(:~
 : Post-install script.
 :
 : Calls the Jinks generator to copy profile files (base-page.html,
 : nav.xqm, site-config.xqm, exist-site.css) into this app.
 : Required for autodeploy compatibility.
 :)

declare variable $home external;
declare variable $dir external;
declare variable $target external;

let $config := map {
    "label": "Blog",
    "id": "http://exist-db.org/apps/blog",
    "description": "eXist-db project blog",
    "extends": array { "exist-site" },
    "pkg": map {
        "abbrev": "blog",
        "version": "1.0.0-SNAPSHOT"
    },
    "nav": map {
        "items": array {
            map { "abbrev": "dashboard", "title": "Dashboard" },
            map { "abbrev": "docs", "title": "Documentation" },
            map { "abbrev": "notebook", "title": "Notebook" },
            map { "abbrev": "blog", "title": "Blog" }
        }
    }
}

let $_ :=
    if (util:binary-doc-available("/db/apps/jinks/modules/generator.xqm") or
        doc-available("/db/apps/jinks/modules/generator.xqm")) then
        try {
            let $_ := util:import-module(
                xs:anyURI("http://tei-publisher.com/library/generator"),
                "generator",
                xs:anyURI("/db/apps/jinks/modules/generator.xqm")
            )
            let $_ := util:eval('generator:process(map { "overwrite": () }, $config)', false(),
                    (xs:QName("config"), $config))
            (: Fix MIME type for .xqm modules — the generator stores them as
             : application/octet-stream but eXist needs application/xquery :)
            return
                for $mod in xmldb:get-child-resources($target || "/modules")
                where ends-with($mod, ".xqm")
                let $path := $target || "/modules/" || $mod
                where util:binary-doc-available($path) and
                      xmldb:get-mime-type(xs:anyURI($path)) != "application/xquery"
                let $content := util:binary-to-string(util:binary-doc($path))
                let $_ := xmldb:remove($target || "/modules", $mod)
                return xmldb:store($target || "/modules", $mod, $content, "application/xquery")
        } catch * {
            util:log("WARN", "blog: Jinks generator failed: " || $err:description)
        }
    else
        util:log("WARN", "blog: Jinks generator not available. Install Jinks and re-deploy.")

(: Deploy Lucene index config for posts-index to the system config collection :)
let $idx-src := $target || "/data/posts-index/collection.xconf"
let $idx-dst-col := "/db/system/config" || $target || "/data/posts-index"
let $_ :=
    if (doc-available($idx-src)) then
        try {
            let $parts := tokenize(substring-after($idx-dst-col, "/db/system/config/"), "/")
            let $_ :=
                for $i in 1 to count($parts)
                let $path := "/db/system/config/" || string-join(subsequence($parts, 1, $i), "/")
                let $parent-path := "/db/system/config/" || string-join(subsequence($parts, 1, $i - 1), "/")
                let $parent-path := if ($parent-path eq "/db/system/config/") then "/db/system/config" else $parent-path
                where not(xmldb:collection-available($path))
                return xmldb:create-collection($parent-path, $parts[$i])
            return xmldb:store($idx-dst-col, "collection.xconf", doc($idx-src))
        } catch * {
            util:log("WARN", "blog: deploy posts-index config failed: " || $err:description)
        }
    else ()

(: Reindex the posts-index collection so Lucene indexes are built for
 : shadow documents that were stored before the index config existed. :)
let $_ :=
    try {
        xmldb:reindex($target || "/data/posts-index")
    } catch * {
        util:log("WARN", "blog: reindex posts-index failed: " || $err:description)
    }

(: Build search index: create shadow XML documents for all existing posts.
 : The trigger fires for new/updated files, but not for files already in the database,
 : so we call it explicitly here for every .md file under data/posts/. :)
return
    try {
        util:import-module(
            xs:anyURI("http://exist-db.org/xquery/trigger"),
            "trigger",
            xs:anyURI($target || "/modules/trigger.xqm")
        ),
        util:eval(
            'for $year in xmldb:get-child-collections($posts-root)
             let $col := $posts-root || "/" || $year
             for $file in xmldb:get-child-resources($col)
             where ends-with($file, ".md")
             return trigger:after-update-document(xs:anyURI($col || "/" || $file))',
            false(),
            (xs:QName("posts-root"), $target || "/data/posts")
        )
    } catch * {
        util:log("WARN", "blog: search reindex failed: " || $err:description)
    }
