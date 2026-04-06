---json
{
    "templating": {
        "extends": "templates/standalone.html"
    }
}
---
[% template title %][[ $page-title ]][% endtemplate %]

[% template head %]
<link rel="stylesheet" href="[[ $context-path ]]/resources/css/blog.css"/>
<link rel="alternate" type="application/atom+xml" title="Atom Feed" href="[[ $context-path ]]/feed.xml"/>
[% endtemplate %]

[% template content %]
[[ $blog-content ]]
[% endtemplate %]
