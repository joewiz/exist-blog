<div data-template="app:if-editor">
    <header class="admin-header">
        <h1 id="editor-title">New Post</h1>
        <div class="editor-actions">
            <button id="btn-save-draft" class="btn">Save Draft</button>
            <button id="btn-publish" class="btn btn-primary">Publish</button>
            <a data-template="app:admin-link" data-template-href="admin" class="btn btn-secondary">Cancel</a>
        </div>
    </header>

    <div class="editor-layout">
        <div class="editor-sidebar">
            <div class="form-group">
                <label for="post-title">Title</label>
                <input type="text" id="post-title" name="title" required="required"
                       placeholder="Post title"/>
            </div>
            <div class="form-group">
                <label for="post-date">Date</label>
                <input type="date" id="post-date" name="date"/>
            </div>
            <div class="form-group">
                <label for="post-author">Author</label>
                <input type="text" id="post-author" name="author"
                       placeholder="Author name"/>
            </div>
            <div class="form-group">
                <label for="post-tags">Tags (comma-separated)</label>
                <input type="text" id="post-tags" name="tags"
                       placeholder="release, xquery, performance"/>
            </div>
            <div class="form-group">
                <label for="post-category">Category</label>
                <input type="text" id="post-category" name="category"
                       placeholder="releases"/>
            </div>
            <div class="form-group">
                <label for="post-summary">Summary</label>
                <textarea id="post-summary" name="summary" rows="3"
                          placeholder="Brief description for listings and feeds..."></textarea>
            </div>
            <div class="form-group">
                <label for="post-slug">Slug (auto-generated from title if empty)</label>
                <input type="text" id="post-slug" name="slug"
                       placeholder="my-post-slug"/>
            </div>
        </div>

        <div class="editor-main">
            <div class="editor-panes">
                <div class="editor-pane">
                    <h3>Markdown</h3>
                    <textarea id="markdown-source" placeholder="Write your post in Markdown..."></textarea>
                </div>
                <div class="preview-pane">
                    <h3>Preview</h3>
                    <div id="markdown-preview" class="post-body"></div>
                </div>
            </div>
        </div>
    </div>

    <div data-template="app:editor-scripts"></div>
</div>
