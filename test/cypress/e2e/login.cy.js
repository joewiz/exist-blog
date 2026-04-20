/**
 * E2E tests for login, logout, and protected admin access.
 *
 * All three apps (blog, exist-site-shell, notebook) share the same
 * persistent login session via the org.exist.login domain.
 */

const BLOG    = 'http://localhost:8080/exist/apps/blog';
const SHELL   = 'http://localhost:8080/exist/apps/exist-site-shell';

describe('Blog login / logout', () => {

  beforeEach(() => {
    cy.clearCookies();
  });

  it('GET /login serves the login form', () => {
    cy.visit('/login');
    cy.get('form').should('exist');
    cy.get('input[name="user"]').should('exist');
    cy.get('input[name="password"]').should('exist');
    cy.get('input[name="duration"]').should('have.value', 'P7D');
  });

  it('POST /login with valid credentials returns JSON with user', () => {
    cy.request({
      method: 'POST',
      url: '/login',
      form: true,
      body: { user: 'admin', password: '', duration: 'P7D' },
    }).then((resp) => {
      expect(resp.status).to.eq(200);
      expect(resp.body).to.have.property('user', 'admin');
      expect(resp.body).to.have.property('isAdmin');
    });
  });

  it('POST /login with bad credentials returns 401', () => {
    cy.request({
      method: 'POST',
      url: '/login',
      form: true,
      body: { user: 'admin', password: 'wrongpassword', duration: 'P7D' },
      failOnStatusCode: false,
    }).then((resp) => {
      expect(resp.status).to.eq(401);
    });
  });

  it('unauthenticated access to /admin redirects to /login', () => {
    cy.request({
      url: `${BLOG}/admin`,
      followRedirect: false,
    }).then((resp) => {
      expect(resp.status).to.eq(302);
      expect(resp.headers.location).to.include('/login');
    });
  });

  it('authenticated access to /admin succeeds', () => {
    cy.loginApi();
    cy.visit('/admin');
    cy.get('h1, .admin-header').should('exist');
  });

  it('logout clears the session and redirects to blog home', () => {
    cy.loginApi();
    cy.request({
      url: `${BLOG}/logout`,
      followRedirect: false,
    }).then((resp) => {
      expect(resp.status).to.eq(302);
    });
    // After logout, /admin should redirect to login
    cy.request({
      url: `${BLOG}/admin`,
      followRedirect: false,
    }).then((resp) => {
      expect(resp.status).to.eq(302);
      expect(resp.headers.location).to.include('/login');
    });
  });

});

describe('Cross-app login sharing (org.exist.login)', () => {

  beforeEach(() => {
    cy.clearCookies();
  });

  it('logging in via blog authenticates the exist-site-shell navbar', () => {
    // Login via blog
    cy.request({
      method: 'POST',
      url: `${BLOG}/login`,
      form: true,
      body: { user: 'admin', password: '', duration: 'P7D' },
    });
    // The shell navbar should now show username, not Login link
    cy.visit(`${SHELL}/`);
    cy.get('.site-user').should('not.contain', 'Login');
    cy.get('.site-user').should('contain', 'admin');
  });

  it('logging in via exist-site-shell authenticates the blog navbar', () => {
    // Login via exist-site-shell
    cy.request({
      method: 'POST',
      url: `${SHELL}/login`,
      form: true,
      body: { user: 'admin', password: '', duration: 'P7D' },
    });
    // The blog navbar should now show username, not Login link
    cy.visit(`${BLOG}/`);
    cy.get('.site-user').should('not.contain', 'Login');
    cy.get('.site-user').should('contain', 'admin');
  });

});
