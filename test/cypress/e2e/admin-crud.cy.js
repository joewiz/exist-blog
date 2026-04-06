/**
 * E2E tests for admin CRUD operations via the Roaster API.
 */
describe('Admin CRUD API', () => {
  let testSlug;

  it('lists existing posts', () => {
    cy.apiRequest({ method: 'GET', url: '/posts' }).then((resp) => {
      expect(resp.status).to.eq(200);
      expect(resp.body).to.have.property('posts');
      expect(resp.body.posts).to.be.an('array');
      expect(resp.body.posts.length).to.be.at.least(2);
    });
  });

  it('creates a new draft post', () => {
    cy.createTestPost({
      title: 'Cypress Create Test',
      status: 'draft',
      slug: `cy-create-${Date.now()}`,
      content: '# Created by Cypress\n\nThis tests the create endpoint.',
    }).then((slug) => {
      testSlug = slug;
      expect(slug).to.include('cy-create-');
    });
  });

  it('reads the created post', () => {
    cy.apiRequest({ method: 'GET', url: `/posts/${testSlug}` }).then((resp) => {
      expect(resp.status).to.eq(200);
      expect(resp.body.title).to.eq('Cypress Create Test');
      expect(resp.body.status).to.eq('draft');
      expect(resp.body.body).to.include('Created by Cypress');
    });
  });

  it('updates the post title and status', () => {
    const updatedSource = [
      '---',
      'title: "Cypress Updated Post"',
      'date: 2026-04-04',
      'author: Cypress',
      'tags: [test, updated]',
      'status: published',
      '---',
      '',
      '# Updated by Cypress',
      '',
      'This post has been updated.',
    ].join('\n');

    cy.apiRequest({
      method: 'PUT',
      url: `/posts/${testSlug}`,
      body: { source: updatedSource },
      headers: { 'Content-Type': 'application/json' },
    }).then((resp) => {
      expect(resp.status).to.eq(200);
      expect(resp.body.success).to.be.true;
    });
  });

  it('verifies the update was applied', () => {
    cy.apiRequest({ method: 'GET', url: `/posts/${testSlug}` }).then((resp) => {
      expect(resp.status).to.eq(200);
      expect(resp.body.title).to.eq('Cypress Updated Post');
      expect(resp.body.status).to.eq('published');
    });
  });

  it('deletes the post', () => {
    cy.apiRequest({ method: 'DELETE', url: `/posts/${testSlug}` }).then((resp) => {
      expect(resp.status).to.eq(200);
      expect(resp.body.success).to.be.true;
      expect(resp.body.deleted).to.eq(testSlug);
    });
  });

  it('confirms the post is gone (404)', () => {
    cy.apiRequest({ method: 'GET', url: `/posts/${testSlug}` }).then((resp) => {
      expect(resp.status).to.eq(404);
    });
  });

  it('rejects creation of a duplicate post', () => {
    cy.createTestPost({ slug: 'dup-test' }).then((slug) => {
      // Try to create the same slug again
      cy.apiRequest({
        method: 'POST',
        url: '/posts',
        body: {
          title: 'Duplicate',
          date: '2026-04-04',
          slug: 'dup-test',
          content: 'dup',
        },
        headers: { 'Content-Type': 'application/json' },
      }).then((resp) => {
        expect(resp.status).to.eq(409);
      });

      // Cleanup
      cy.deleteTestPost(slug);
    });
  });

  it('returns 404 for non-existent post', () => {
    cy.apiRequest({ method: 'GET', url: '/posts/9999/does-not-exist' }).then((resp) => {
      expect(resp.status).to.eq(404);
    });
  });
});
