xquery version "3.1";

(:~
 : Blog application configuration module.
 :)
module namespace config="http://exist-db.org/apps/blog/config";

declare namespace repo="http://exist-db.org/xquery/repo";
declare namespace expath="http://expath.org/ns/pkg";

(:~ Determine the application root collection from the current module load path. :)
declare variable $config:app-root :=
    let $rawPath := system:get-module-load-path()
    let $modulePath :=
        if (starts-with($rawPath, "xmldb:exist://")) then
            if (starts-with($rawPath, "xmldb:exist://embedded-eXist-server")) then
                substring($rawPath, 36)
            else
                substring($rawPath, 15)
        else
            $rawPath
    return
        substring-before($modulePath, "/modules")
;

declare variable $config:repo-descriptor := doc($config:app-root || "/repo.xml")/repo:meta;

declare variable $config:expath-descriptor := doc($config:app-root || "/expath-pkg.xml")/expath:package;

(:~ Collection where blog post Markdown files are stored :)
declare variable $config:posts-root := $config:app-root || "/data/posts";

(:~ Blog title :)
declare variable $config:blog-title := "eXist-db Blog";

(:~ Blog tagline :)
declare variable $config:blog-tagline := "News, releases, and developer stories from the eXist-db project";

(:~ Blog author :)
declare variable $config:blog-author := "The eXist-db Authors";

(:~ Base URL for the blog (relative to eXist context) :)
declare variable $config:blog-base :=
    let $target := $config:repo-descriptor//repo:target/string()
    return
        request:get-context-path() || "/apps/" || $target
;

(:~ Number of posts per page :)
declare variable $config:posts-per-page := 10;

(:~ Login domain :)
declare variable $config:login-domain := "org.exist.login";

(:~ Check if exist-markdown module is available :)
declare variable $config:markdown-available :=
    try {
        util:import-module(xs:anyURI("http://exist-db.org/xquery/markdown"), "md",
            xs:anyURI("http://exist-db.org/xquery/markdown")),
        true()
    } catch * {
        false()
    }
;
