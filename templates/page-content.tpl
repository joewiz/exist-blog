---json
{
    "templating": {
        "extends": "templates/base-page.html"
    }
}
---
[% template title %][[ $page-title ]][% endtemplate %]

[% template head %]
<link rel="stylesheet" href="[[ $context-path ]]/resources/css/blog.css"/>
<link rel="alternate" type="application/atom+xml" title="Atom Feed" href="[[ $context-path ]]/feed.xml"/>
[% if $has-cells %]
<script type="module" src="https://cdn.jsdelivr.net/npm/@jinntec/jinn-codemirror@1.18.2/dist/jinn-codemirror-bundle.js"></script>
<script type="module" src="[[ $context-path ]]/resources/js/blog-cell.js"></script>
[% endif %]
[% endtemplate %]

[% template content %]
[[ $blog-content ]]
[% endtemplate %]
