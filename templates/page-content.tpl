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
<script defer="defer" src="[[ $context-path ]]/resources/js/highlight-bundle.js"></script>
<script defer="defer" src="[[ $context-path ]]/resources/js/blog.js"></script>
[% if $has-cells %]
<script type="module" src="https://cdn.jsdelivr.net/npm/@jinntec/jinn-codemirror@1.18.2/dist/jinn-codemirror-bundle.js"></script>
<script type="module" src="[[ $context-path ]]/resources/js/blog-cell.js"></script>
[% endif %]
[% endtemplate %]

[% template content %]
<div class="blog-app">
    <nav class="app-tabs" aria-label="Blog navigation">
        <ul>
            <li><a href="[[ $context-path ]]/" class="[[ $tabs?posts ]]">Posts</a></li>
            <li><a href="[[ $context-path ]]/archive" class="[[ $tabs?archive ]]">Archive</a></li>
            <li><a href="[[ $context-path ]]/search" class="[[ $tabs?search ]]">Search</a></li>
            [% if $is-admin %]
            <li><a href="[[ $context-path ]]/admin" class="[[ $tabs?admin ]]">Admin</a></li>
            [% endif %]
        </ul>
    </nav>
    <section class="blog-content">
        [[ $blog-content ]]
    </section>
</div>
[% endtemplate %]
