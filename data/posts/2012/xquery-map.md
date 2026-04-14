---
title: "Adding a Map Datatype to XQuery"
date: 2012-06-01
author: "wolf"
tags: []
status: published
migrated-from: AtomicWiki
original-id: "XQueryMap"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/XQueryMap"
---

<div class="section">

# Introduction

The "standard" way of passing a complex data structure in XQuery is to create an XML fragment and later query it using XPath. This approach works well most of the time, but sometimes you just can't use it:

- wrapping stored data into an XML fragment will create a new copy of the data in memory (even though eXist-db will defer this until the data is actually used). Wrapping a large query result into an XML structure may thus use a considerable amount of memory.
- the reference to the original document gets lost.
- the power of higher-order functions in XQuery 3.0 makes me wish I could create data structures containing function items as values.

Maps provide a solution to the problems above. Michael Kay has posted a well thought out [proposal](http://dev.saxonica.com/blog/mike/2012/01/#000188) for maps, which I decided to implement a few weeks ago.

Let's have a quick look at the map datatype as proposed by Michael and implemented in the current trunk of eXist-db. Note that this is not part of the XQuery 3.0 specification - though it is considered for later inclusion - and may be subject to change.

<div class="section">

# Creating a Map

You create a new map through either the literal syntax or the functions `map:new` and `map:entry`. Here's the literal syntax:

``` xquery
let $daysOfWeek :=
    map { 
        "Sunday" := 1,
        "Monday" := 2,
        "Tuesday" := 3, 
        "Wednesday" := 4, 
        "Thursday" := 5, 
        "Friday" := 6, 
        "Saturday" := 7
    }
```

The keys are arbitrary atomic values while any sequence can be used as value. You are thus not limited to string keys: dates, numbers or QNames will work as well. Keys are compared for equality using the eq operator under the map's collation.

`map:entry` creates a map with a single key/value pair. Use this to create map items programmatically in combination with `map:new` (see `map:new` below):

``` xquery
map:entry("Sunday", 1)
```

`map:new` creates either an empty map or a new map from a sequence of maps. It accepts an optional collation string as second parameter:

``` xquery
let $daysOfWeek := 
    (
        "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", 
        "Saturday", "Sunday"
    )
let $map := 
    map:new(
        for $day at $pos in days 
        return
            map:entry($day, $pos), "?strength=primary"
    )
```

As you can see, the only way to create a map from a sequence programmatically is to merge single-item maps into the new map. The map implementation in eXist-db makes sure this is not too expensive (by using a lightweight wrapper for single key/value pairs).

In this example, the collation string `"?strength=primary"` causes keys to be compared in a case-insensitive way.

<div class="section">

# Look Up

To look up a key, use `map:get`:

``` xquery
map:get($map, "Tuesday")
```

But wait, there's a real cool shortcut to do a look up: a map is also a function item, which means you can directly call it as a function, passing the key to retrieve as single parameter:

``` xquery
$map("Tuesday")
```

Calling the map as a function item otherwise just behaves like `map:get`.

Because the empty sequence is allowed as a value, `map:get` does not tell you for sure if a key exists in a map or not. You can use `map:contains` to see if a key is present in the map:

``` xquery
map:contains($map, "Tuesday")
```

`map:keys` retrieves all keys in the map as a sequence:

``` xquery
map:keys($map)
```

Please note that the order in which keys are returned is implementation-defined, so don't rely on it. In fact, eXist-db uses two different map implementations for better performance, depending on collation settings and key types.

Here's a complete example which combines the functions to access a map:

``` xquery
xquery version "1.0";

let $workDays :=
    map { 
        "Monday" := 2,
        "Tuesday" := 3, 
        "Wednesday" := 4, 
        "Thursday" := 5, 
        "Friday" := 6
    }
let $daysOfWeek :=
    map:new(($workDays, map { "Sunday" := 1, "Saturday" := 7 }))
for $day in map:keys($daysOfWeek)
order by map:get($daysOfWeek, $day)
return
    <day n="{$daysOfWeek($day)}" atWork="{map:contains($workDays, $day)}">{$day}</day>
```

<div class="section">

# Maps are Immutable

To remove a key/value pair, call

``` xquery
let $newMap := map:remove("Sunday")
```

At this point we definitely need to talk about an important feature: maps are immutable! Adding or removing a key/value pair will result in a new map. To illustrate this with an example:

``` xquery
let $daysOfWeek :=
map { "Sunday" := 1, "Monday" := 2, "Tuesday" := 3, "Wednesday" := 4, "Thursday" := 5, "Friday" := 6, "Saturday" := 7 }
let $workDays := map:remove($daysOfWeek, "Sunday")
return (
    map:contains($daysOfWeek, "Sunday") (: Still there :),
    map:contains($workDays, "Sunday") (: Nope :)
)
```

Internally, eXist-db uses an efficient implementation of persistent immutable maps and hash tables taken from [clojure](http://clojure.org/) , another lisp-like, functional language for the Java VM.

<div class="section">

# Use Cases

So far I found maps to be useful in a number of scenarios:

1.  in my HTML templating framework for passing around application data between templates. In this case the sequences stored in the map can potentially be very large, e.g. if they include the result of queries into the database. Wrapping the data into an in-memory fragment would thus be a bad idea.
2.  to pass optional configuration parameters into a library module.
3.  to introduce additional levels of abstraction when working with heterogeneous data sets.

<div class="section">

## Function Items as Values

To understand the last scenario, we have to take a closer look at an important feature of maps: one can use function items as map values! For example, a library module may allow the calling module to register an optional function for resolving a resource, which only the calling module can know how to find:

``` xquery
let $configuration := map {
    "resolve": function($relPath as xs:string) { (: resolve resource :) }
}
```

You can even use maps and function items to simulate "objects". For example, one of my library modules has to display a short summary of documents using two different schemas: docbook and TEI. It thus needs to extract common metadata like title or author from the documents. Using maps, I could create a wrapper around the documents, which provides functions to access the data in object-oriented style:

``` xquery
xquery version "3.0";

declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace db="http://docbook.org/ns/docbook";

declare function local:tei($root as element()) as map(xs:string, function(*)) {
    map {
        "title" := function() as xs:string {
            $root//tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title/string()
        }
    }
};

declare function local:docbook($root as element()) as map(xs:string, function(*)) {
    map {
        "title" := function() as xs:string {
            $root//db:info/db:title/string()
        }
    }
};

declare function local:wrap($root as element()) as map(xs:string, function(*))? {
    typeswitch ($root)
        case element(tei:TEI) return local:tei($root)
        case element(db:article) return local:docbook($root)
        default return ()
};

<ul>
{
    for $doc in (doc("/db/db-test.xml")/*, doc("/db/tei-test.xml")/*)
    let $wrapped := local:wrap($doc)
    return
        <li>{$wrapped("title")()}</li>
}
</ul>
```

This approach has its limitations. There's no guarantee that the maps returned by local:wrap do indeed have a "title" function. XQuery is not - and was not designed to be - an object-oriented language. However, I can see that the technique could improve reusability of code libraries.

</div>

</div>

<div class="section">

# Availability

Maps as a data type are currently available in eXist-db trunk and will likely go into the final 2.0 release (only minor additions to the query engine were required). If you would like to test them right now, feel free to [check out](http://exist-db.org/exist/building.xml#svn) trunk.

</div>

</div>

</div>

</div>

</div>
