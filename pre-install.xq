xquery version "3.1";

(:~
 : Pre-installation script for the blog application.
 : Creates necessary collections, the blog-editor group, and deploys index configuration.
 :)

import module namespace util="http://exist-db.org/xquery/util";

(: The target collection is passed in by the package manager :)
declare variable $home external;
declare variable $dir external;
declare variable $target external;

(: Create data collections if they don't exist :)
let $data-collections := (
    $target || "/data",
    $target || "/data/posts",
    $target || "/resources/images/posts"
)
return (
    for $coll in $data-collections
    return
        if (xmldb:collection-available($coll)) then ()
        else
            let $parent := replace($coll, "/[^/]+$", "")
            let $name := replace($coll, "^.*/", "")
            return xmldb:create-collection($parent, $name),

    (: Create blog-editor group if it doesn't exist :)
    if ("blog-editor" = sm:list-groups()) then ()
    else sm:create-group("blog-editor", "Blog editors who can create and manage posts"),

    (: Deploy index configuration for the posts collection :)
    let $posts-collection := $target || "/data/posts"
    let $xconf := doc($dir || "/collection.xconf")
    let $config-collection := "/db/system/config" || $posts-collection
    return (
        if (xmldb:collection-available($config-collection)) then ()
        else
            let $parent := replace($config-collection, "/[^/]+$", "")
            let $name := replace($config-collection, "^.*/", "")
            return xmldb:create-collection($parent, $name),

        xmldb:store($config-collection, "collection.xconf", $xconf)
    )
)
