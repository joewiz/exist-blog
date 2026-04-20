<div data-template="app:post-list">
    <header class="blog-header">
        <h1>eXist-db Blog</h1>
        <p class="blog-tagline">News, releases, and developer stories from the eXist-db project</p>
    </header>

    <div class="blog-layout">
        <div data-template="app:post-summaries"></div>

        <aside class="blog-sidebar">
            <section class="sidebar-section">
                <h3>Tags</h3>
                <div data-template="app:tag-cloud"/>
            </section>

            <section class="sidebar-section">
                <h3>Subscribe</h3>
                <a href="feed.xml" class="feed-link">Atom Feed</a>
            </section>
        </aside>
    </div>
</div>
