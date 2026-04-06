/**
 * E2E tests for public blog pages.
 */
describe('Blog public pages', () => {

  it('renders the blog index with posts', () => {
    cy.visit('/');
    cy.get('.blog-header h1').should('contain', 'eXist-db Blog');
    cy.get('.post-summary').should('have.length.at.least', 1);
    cy.get('.post-summary .post-title a').first().should('have.attr', 'href');
  });

  it('renders a single post with markdown content', () => {
    cy.visit('/2026/03-exist-7-preview');
    cy.get('.post-title').should('contain', "eXist-db 7.0 Preview");
    cy.get('.post-body').should('exist');
    cy.get('.post-body h2').should('have.length.at.least', 1);
  });

  it('filters posts by tag', () => {
    cy.visit('/tag/release');
    cy.get('.post-summary').should('have.length.at.least', 1);
  });

  it('serves a valid Atom feed', () => {
    cy.request('/feed.xml').then((resp) => {
      expect(resp.status).to.eq(200);
      expect(resp.headers['content-type']).to.include('atom+xml');
      expect(resp.body).to.include('<atom:feed');
      expect(resp.body).to.include('<atom:entry');
    });
  });

  it('serves a valid XML sitemap', () => {
    cy.request('/sitemap.xml').then((resp) => {
      expect(resp.status).to.eq(200);
      expect(resp.body).to.include('urlset');
    });
  });

  it('renders the archive page', () => {
    cy.visit('/archive');
    cy.get('h1').should('contain', 'Archive');
  });

  it('serves static CSS', () => {
    cy.request('/resources/css/blog.css').then((resp) => {
      expect(resp.status).to.eq(200);
      expect(resp.headers['content-type']).to.include('css');
    });
  });
});
