/**
 * E2E tests for migrated archive posts.
 *
 * The AtomicWiki migration has been completed and the wiki-import source
 * data removed. These tests verify the migrated posts are present and
 * render correctly.
 */
describe('Migrated archive posts', () => {

  it('archive posts exist in the post list', () => {
    cy.apiRequest({ method: 'GET', url: '/posts' }).then((resp) => {
      expect(resp.status).to.eq(200);
      const archivePosts = resp.body.posts.filter((p) =>
        p.slug.startsWith('archive/')
      );
      expect(archivePosts.length).to.be.at.least(50);
    });
  });

  it('an archive post renders with proper HTML', () => {
    cy.apiRequest({ method: 'GET', url: '/posts' }).then((resp) => {
      const archivePost = resp.body.posts.find((p) =>
        p.slug.startsWith('archive/')
      );
      expect(archivePost).to.exist;

      cy.visit(`/${archivePost.slug}`);
      cy.get('.post-body, .post-detail').should('exist');
      cy.get('.post-title').should('not.be.empty');
    });
  });

  it('archive pages return 200', () => {
    cy.request('/archive/2017/atom-existdb').then((resp) => {
      expect(resp.status).to.eq(200);
    });
  });
});
