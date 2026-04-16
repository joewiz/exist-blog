xquery version "3.1";

(:~
 : Pre-installation script for the blog application.
 : Creates necessary collections, the blog-editor group, and deploys index configuration.
 :
 : NOTE: This runs BEFORE package contents are stored, so $target may not exist yet.
 : We must create collections from the top down.
 :)

(: The target collection is passed in by the package manager :)
declare variable $home external;
declare variable $dir external;
declare variable $target external;

(:~
 : Recursively ensure a collection path exists, creating each segment as needed.
 :)
declare function local:ensure-collection($path as xs:string) {
    if (xmldb:collection-available($path)) then ()
    else
        let $parent := replace($path, "/[^/]+$", "")
        let $name := replace($path, "^.*/", "")
        return (
            local:ensure-collection($parent),
            xmldb:create-collection($parent, $name)
        )
};

(: Create data collections :)
let $_ := (
    local:ensure-collection($target || "/data/posts"),
    local:ensure-collection($target || "/data/posts-index"),
    local:ensure-collection($target || "/resources/images/posts")
)

(: Create blog-editor group if it doesn't exist :)
let $_ :=
    if ("blog-editor" = sm:list-groups()) then ()
    else sm:create-group("blog-editor", "Blog editors who can create and manage posts")

(: Deploy collection.xconf (trigger config) for data/posts :)
let $posts-collection := $target || "/data/posts"
let $config-collection := "/db/system/config" || $posts-collection
let $_ := local:ensure-collection($config-collection)
let $_ :=
    if (doc-available($dir || "/collection.xconf")) then
        xmldb:store($config-collection, "collection.xconf", doc($dir || "/collection.xconf"))
    else if (util:binary-doc-available($dir || "/collection.xconf")) then
        xmldb:store($config-collection, "collection.xconf",
            util:binary-to-string(util:binary-doc($dir || "/collection.xconf")),
            "application/xml")
    else ()

(: Deploy posts-index-collection.xconf (Lucene index) for data/posts-index :)
let $index-collection := $target || "/data/posts-index"
let $index-config-collection := "/db/system/config" || $index-collection
let $_ := local:ensure-collection($index-config-collection)
return
    if (doc-available($dir || "/posts-index-collection.xconf")) then
        xmldb:store($index-config-collection, "collection.xconf",
            doc($dir || "/posts-index-collection.xconf"))
    else if (util:binary-doc-available($dir || "/posts-index-collection.xconf")) then
        xmldb:store($index-config-collection, "collection.xconf",
            util:binary-to-string(util:binary-doc($dir || "/posts-index-collection.xconf")),
            "application/xml")
    else ()
