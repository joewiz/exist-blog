<div data-template="app:if-editor">
    <header class="admin-header">
        <h1>Blog Admin</h1>
        <div class="admin-header-actions">
            <a data-template="app:admin-link" data-template-href="admin/editor" class="btn btn-primary">New Post</a>
            <a data-template="app:admin-link" data-template-href="logout" class="btn btn-secondary">Log Out</a>
        </div>
    </header>

    <div class="admin-post-list" id="admin-post-list">
        <table class="admin-table">
            <thead>
                <tr>
                    <th>Title</th>
                    <th>Date</th>
                    <th>Author</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="admin-posts-body">
            </tbody>
        </table>
    </div>

    <div data-template="app:admin-scripts"></div>
</div>
