---
title: "XQuery 3.1 Arrays and JSON Support"
date: 2015-02-23
author: "wolf"
tags:
  - "article"
status: published
migrated-from: AtomicWiki
original-id: "XQuery31"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/XQuery31"
---

<div class="row">
    <div class="col-md-6">
        The current development version of eXistdb includes full support for the array data type and related features from the [XQuery 3.1 Candidate Recommendation](http://www.w3.org/TR/xquery-31/#id-arrays). In combination with maps, arrays allow for a more "natural" representation of JSON in XQuery. Processing JSON or interfacing with external services returning JSON has become a lot more straightforward.
        
        But even if you are only mildly interested in JSON, arrays are a welcome addition to the XQuery language, mainly because unlike sequences, arrays can be nested. I guess most XQuery programmers have encountered a situation in which it would have been nice to return a sequence of sequences from a function. And sometimes you may want to indicate that particular items in a result sequence are empty. With arrays you can do all that. Arrays may contain other arrays or maps, sequences or even the empty sequence as members.
    </div>
    <div class="col-md-6">
        <figure>
        <iframe width="560" height="315" src="https://www.youtube.com/embed/XqehyfyjYWA" frameborder="0" allowfullscreen></iframe>
        <figcaption>Recorded presentation of this article during the eXistdb user pre-conference in Prague</figcaption>
        </figure>
    </div>
</div>

# Array Constructors

Array constructors come in two flavors: square and curly constructors. The square constructor will look familiar to most people:

```xquery
let $array := [1, (), (3, 4)]
return
    $array(3)
```

Within the square constructor, the "," is just a separator (like in a function call), so the resulting array will correspond to the comma-separated members. In the example above we're retrieving the third member using `$array(3)`, which is the sequence containing numbers 3 and 4. Getting the second member with `$array(2)` will return the empty sequence accordingly.

The curly constructor behaves slightly different: it takes a sequence of items and creates an array member from each of them:

```xquery
let $array := array { 1, (), (3, 4) }
return
    $array(3)
```

Above query returns "4"! See the difference? The "," in this case is the XQuery sequence constructor, so the sequence from which the array is built is 1, 3, 4.

As already announced, you can arbitrarily mix sequences, arrays and maps, resulting e.g. in:

```xquery
let $books := [
    map {
        "title": "eXist",
        "author": [ [ "Adam", "Retter" ], ["Erik", "Siegel" ] ],
        "language": "English"
    },
    map {
        "title": "XQuery",
        "author": [ [ " Priscilla", "Walmsley" ] ],
        "language": "English"
    }
]
```

# Array Lookups

Just like a map, an array is also a function, which accepts a single integer parameter corresponding to the position of the member to retrieve (as always in XQuery, counting starts at 1). We have seen simple examples above. For nested data structures, just chain the function calls, e.g.:

```xquery
$books(2)("title")
```

Alternatively, there's a lookup operator, which is often a bit easier to read. It works on arrays as well as maps (but not on other data types):

```xquery
$books?2?title
```

The lookup may also appear inside a predicate. In this case, the left hand argument (the array or map) is often skipped and defaults to the context item:

```xquery
$books?\*[?title = "eXist"]?language
```

The operator expects an integer, name, parenthesized expression or a wildcard as its right hand argument. So to use e.g. a variable for the lookup, wrap it into parens:

```xquery
let $field := "title"
return
    $books?2?($field)
```

Note: because `$books` is an array, the lookup argument must evaluate to a sequence of integers or you'll see an error. It is possible to look up more than one array item at a time, e.g.: `$books?(1 to 2)?title`.

The wildcard returns the keys or members of a map or array. When used on a map, it results in a sequence of keys, whereas on an array, you get a sequence of members:

```xquery
["Hello", "world", "!"]?\*
```

Use the wildcard as a quick way to iterate an array:

```xquery
for $book in $books?\*
return
    $book?title
```

# Function Library

The XQuery 3.1 functions spec also includes a huge library of functions to process and modify arrays. All functions use the prefix `array`.

| [array:size](http://www.w3.org/TR/xpath-functions-31/#func-array-size) | returns the size of the array |
| [array:head](http://www.w3.org/TR/xpath-functions-31/#func-array-head) | returns the first member |
| [array:tail](http://www.w3.org/TR/xpath-functions-31/#func-array-tail) | an array with all members except the first |
| [array:subarray](http://www.w3.org/TR/xpath-functions-31/#func-array-subarray) | creates an array containing a subset of members |
| [array:reverse](http://www.w3.org/TR/xpath-functions-31/#func-array-reverse) | reverse members |
| [array:for-each](http://www.w3.org/TR/xpath-functions-31/#func-array-for-each) | iterate over members |
| [array:filter](http://www.w3.org/TR/xpath-functions-31/#func-array-filter) | filter the arrays with a function |
| [array:fold-left](http://www.w3.org/TR/xpath-functions-31/#func-array-fold-left) | apply function to members and collect results from left to right |
| [array:fold-right](http://www.w3.org/TR/xpath-functions-31/#func-array-fold-right) | apply function to members and collect results from right to left |
| [array:for-each-pair](http://www.w3.org/TR/xpath-functions-31/#func-array-for-each-pair) | iterate members pair-wise |
| [array:append](http://www.w3.org/TR/xpath-functions-31/#func-array-append) | append a member to an array |
| [array:insert-before](http://www.w3.org/TR/xpath-functions-31/#func-array-insert-before) | insert new member |
| [array:remove](http://www.w3.org/TR/xpath-functions-31/#func-array-remove) | remove member |
| [array:join](http://www.w3.org/TR/xpath-functions-31/#func-array-join) | Concatenates the contents of several arrays into a single array |

As all data types in XQuery, arrays are **immutable** and cannot be modified. The functions above will thus always return a new array. eXist tries to implement this in an efficient way for functions like array:tail, array:append, array:subarray, array:remove without creating redundant copies.

Please note that I did not implement `array:sort` yet. It will be added later.

Many of the functions mirror other functions already available in the standard function library, but take an array instead of a sequence as input. For example, `array:fold-left` works like `fn:fold-left`.

```xquery
declare function local:price($hoursPerTask as array(xs:integer), $rate as xs:double) as xs:double {
    array:fold-left($hoursPerTask, 0.0, function($sum, $hours) {
        $sum + $hours * $rate
    })
};

local:price([3, 8, 6, 5, 2], 96.0)
```

In this example we multiply the hours required for some task by our hourly rate and return the sum.

# JSON Support

Obviously, representing JSON data within an XQuery has become straightforward using maps and arrays. The function [fn:parse-json](http://www.w3.org/TR/xpath-functions-31/#func-parse-json) takes a string of JSON data and returns either a map (for a JSON object), an array, an atomic value (xs:string, xs:double for numbers or xs:boolean), or the empty sequence (corresponding to `null` in JSON):

```xquery
let $json := '{"user": "bob", "id": 10, "valid": true}'
let $user := parse-json($json)
return
    $user?id
```

Note that by default `parse-json` is rather strict about the JSON syntax. For example, strings must use double quotes and duplicate keys generate an error. You can tell the function to be more relaxed about the JSON syntax by passing in a map of options:

```xquery
let $json := "{'user': 'bob', 'id': 10, 'valid': true}"
let $options := map { "liberal": true(), "duplicates": "use-last" }
let $user := parse-json($json, $options)
return
    $user?id
```

To see the function in action on a real-world example, assume we would like to retrieve a list of commits from a git repository, using the [HTTP/JSON API](https://developer.github.com/v3/repos/commits/) provided by github:

```xquery
xquery version "3.1";

import module namespace http="http://expath.org/ns/http-client";

declare function local:log($json as array(\*)) {
    \<table>
    {
        for $entry in $json?\*
        let $commit := $entry?commit
        return
            \<tr>
                \<td>{$commit?committer?date}\</td>
                \<td>{$commit?committer?name}\</td>
                \<td>{$commit?message}\</td>
            \</tr>
    }
    \</table>
};

let $url := 
"https://api.github.com/repos/eXist-db/exist/commits?since=2015-01-01T00:00:00Z"
let $request := <http:request method="GET" href="{$url}" timeout="30"/>
let $response := http:send-request($request)
return
    if ($response[1]/@status = "200") then
        local:log(parse-json(util:binary-to-string($response[2])))
    else
        ()
```

Here we're using the httpclient module to talk to the github API, which gives us more control over the communication. But there's also a simpler approach, using the `fn:json-doc`function:

```xquery
let $url := 
"https://api.github.com/repos/eXist-db/exist/commits?since=2015-01-01T00:00:00Z"
return
    local:log(json-doc($url))
```

`fn:json-doc` retrieves the contents of the given URI and parses them using fn:parse-json. It works with external resources as well as binary documents stored in eXist. To access stored resources, just use a local path, e.g. `/db/test/data.json`.

# Serialization

eXistdb has supported serialization to JSON for several years, but the old serializer was based on mapping an XML query result to JSON, which caused some difficulties at times, e.g. if you had to produce an array for a certain property, even if it was empty. Contrary to this, the new JSON output method defined by the [XQuery 3.1 Serialization spec](http://www.w3.org/TR/xslt-xquery-serialization-31/#json-output) is straightforward: it takes an array, map, atomic value or empty sequence and produces valid JSON.

The JSON serializer is selected if you set the serialization option `method` to `json`. This applies to both, the old and the new serializer. To distinguish between the two while preserving backwards compatibility, we use the following convention:

* if the sequence to serialize is a single XML element node, the old serializer is used
* if the sequence contains more than one item or the single item is not an XML element, it will be passed to the new serializer

This convention allows us to run all the old code unchanged without violating the 3.1 specification too much (according to the specs, a single XML element would be serialized to a JSON string).

To see the serializer in action, use the `fn:serialize` function:

```xquery
xquery version "3.1";

declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";

let $array := map { "k1": array { "v1", "v2" }, "k2": "v3" }
return
    serialize($array, 
        \<output:serialization-parameters>
            \<output:method>json\</output:method>
        \</output:serialization-parameters>)
```

or save the query and define the serialization method as an output option:

```xquery
xquery version "3.1";

declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "json";
declare option output:media-type "application/json";

map { "k1": array { "v1", "v2" }, "k2": "v3" }
```

# Other Functions Using Arrays
Some applications require calling a function dynamically without knowing the number of arguments it takes in advance. Without arrays, this had been rather difficult to solve: because sequences cannot be nested, passing arguments containing more than one item has been tricky. For example, we solved this in the templating module by using function items. The [code](https://github.com/eXist-db/shared-resources/blob/master/content/templates.xql#L213) becomes rather bloated though.

The newly added [fn:apply](http://www.w3.org/TR/xpath-functions-31/#func-apply) function makes this straightforward. It takes a function item as first argument and an array containing the parameters as second:

```xquery
fn:apply(sum#1, [(1, 2, 3)])
```

# Availability

The new features will be available in the eXistdb 2.3 release, but we encourage users to help us testing. We tried to preserve backwards compatibility with existing XQuery code, so most, if not all, apps should work as before. 

To experiment with arrays and JSON, just build from [source](https://github.com/eXist-db/exist) or use a [nightly](http://static.adamretter.org.uk/exist-nightly/). You may look through the [test cases](https://github.com/eXist-db/exist/blob/develop/test/src/xquery/arrays/arrays.xql) for some inspiration.

Finally, I also recommend watching Dannes' [presentation on Mongrel](http://youtu.be/liGP7f9E5xw): the MongoDB extension driver for eXistdb, which will rely on the features described in this article.