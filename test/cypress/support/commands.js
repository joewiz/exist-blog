/**
 * Custom Cypress commands for blog testing.
 */

const API_BASE = 'http://localhost:8080/exist/apps/blog/api';

/**
 * Log in via the blog's login endpoint with session caching.
 */
Cypress.Commands.add('loginApi', () => {
  cy.session(
    'admin-login',
    () => {
      cy.request({
        method: 'POST',
        url: '/exist/apps/blog/login',
        form: true,
        body: {
          user: 'admin',
          password: '',
          duration: 'P7D',
        },
      }).then(({ headers }) => {
        const sessionCookie = headers['set-cookie']?.find((c) =>
          c.startsWith('JSESSIONID=')
        );
        if (sessionCookie) {
          const value = sessionCookie.split(';')[0].split('=')[1];
          cy.setCookie('JSESSIONID', value);
        }
      });
    },
    {
      validate() {
        cy.request({
          url: '/exist/apps/blog/login',
          failOnStatusCode: false,
        }).its('status').should('be.oneOf', [200, 302]);
      },
      cacheAcrossSpecs: true,
    }
  );
});

/**
 * Make an authenticated API request using Basic auth.
 */
Cypress.Commands.add('apiRequest', (options) => {
  return cy.request({
    ...options,
    url: `${API_BASE}${options.url}`,
    headers: {
      ...options.headers,
      Authorization: 'Basic YWRtaW46',
    },
    failOnStatusCode: false,
  });
});

/**
 * Create a test post via API, returning the slug.
 */
Cypress.Commands.add('createTestPost', (overrides = {}) => {
  const post = {
    title: 'Cypress Test Post',
    date: '2026-04-04',
    author: 'Cypress',
    tags: ['test', 'cypress'],
    summary: 'A test post',
    status: 'published',
    slug: `cypress-${Date.now()}`,
    content: '# Test Post\n\nCreated by Cypress.',
    ...overrides,
  };
  return cy.apiRequest({
    method: 'POST',
    url: '/posts',
    body: post,
    headers: { 'Content-Type': 'application/json' },
  }).then((resp) => {
    expect(resp.status).to.eq(200);
    expect(resp.body.success).to.be.true;
    return resp.body.slug;
  });
});

/**
 * Delete a test post via API (cleanup helper).
 */
Cypress.Commands.add('deleteTestPost', (slug) => {
  cy.apiRequest({
    method: 'DELETE',
    url: `/posts/${slug}`,
  });
});
