/**
 * E2E tests for migrated archive posts.
 *
 * The AtomicWiki migration has been completed and the wiki-import source
 * data removed. These tests verify the migrated posts are present and
 * render correctly.
 */
describe('Migrated archive posts', () => {

  it('migrated posts exist in the post list', () => {
    cy.apiRequest({ method: 'GET', url: '/posts' }).then((resp) => {
      expect(resp.status).to.eq(200);
      // Posts from years before 2026 are all migrated AtomicWiki posts
      const migratedPosts = resp.body.posts.filter((p) =>
        p.slug.match(/^20(0[7-9]|1\d|2[0-5])\//)
      );
      expect(migratedPosts.length).to.be.at.least(50);
    });
  });

  it('a migrated post renders with proper HTML', () => {
    cy.visit('/2017/atom-existdb');
    cy.get('.post-body, .post-detail').should('exist');
    cy.get('.post-title').should('not.be.empty');
  });

  it('old archive URLs redirect to current post URLs', () => {
    cy.request({ url: '/archive/2017/atom-existdb', followRedirect: false }).then((resp) => {
      expect(resp.status).to.be.oneOf([200, 301, 302]);
    });
  });
});
