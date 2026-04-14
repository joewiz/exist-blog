/**
 * Blog XQuery cell widget.
 *
 * Activates inline XQuery cells in blog posts — rendered from fenced
 * ```xquery code blocks by blog:render-markdown(). Queries are editable
 * and execute against the exist-api query endpoint.
 *
 * API flow (exist-api cursor pattern):
 *   POST /exist/apps/exist-api/api/query  → { cursor, items }
 *   GET  /exist/apps/exist-api/api/query/{cursor}/results?method=...
 *   DELETE /exist/apps/exist-api/api/query/{cursor}
 */

function escapeHtml(str) {
    return str
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;');
}

/** Resolve the exist-api base from the current page URL. */
function apiBase() {
    const m = window.location.pathname.match(/(.*\/exist)/);
    const ctx = m ? m[1] : '/exist';
    return ctx + '/apps/exist-api';
}

async function runQuery(query, method, indent) {
    const base = apiBase();

    // 1. Execute — returns cursor
    const execResp = await fetch(base + '/api/query', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ query })
    });

    if (!execResp.ok) {
        let msg = `HTTP ${execResp.status}`;
        try {
            const err = await execResp.json();
            if (err.description) msg = err.description;
        } catch (_) {}
        return { error: msg };
    }
    const exec = await execResp.json();

    // Error during compile/eval (no cursor)
    if (exec.description) {
        return { error: exec.description };
    }

    const { cursor, items } = exec;

    try {
        // 2. Fetch results
        const params = new URLSearchParams({ method, count: Math.min(items, 1000) });
        if (indent) params.set('indent', 'yes');

        const resultsResp = await fetch(`${base}/api/query/${cursor}/results?${params}`);
        if (!resultsResp.ok) throw new Error(`HTTP ${resultsResp.status}`);
        const results = await resultsResp.json();

        // results is an array of { type, value, ... }
        const text = results.map(r => r.value ?? '').join('\n');
        return { result: text, count: items };
    } finally {
        // 3. Always close the cursor
        fetch(`${base}/api/query/${cursor}`, { method: 'DELETE' }).catch(() => {});
    }
}

function initCell(cell) {
    const editor = cell.querySelector('jinn-codemirror');
    const runBtn = cell.querySelector('.blog-cell-run');
    const resetBtn = cell.querySelector('.blog-cell-reset');
    const resultEl = cell.querySelector('.blog-cell-result');
    const originalCode = editor?.getAttribute('code') || '';

    // Set editor content once CodeMirror is ready
    if (editor) {
        const setContent = () => {
            if (editor._editor) {
                editor.content = originalCode;
            } else {
                requestAnimationFrame(setContent);
            }
        };
        requestAnimationFrame(setContent);
    }

    function showResult(data, elapsed) {
        resultEl.style.display = 'block';
        resultEl.innerHTML = '';

        if (data.error) {
            const errEl = document.createElement('div');
            errEl.className = 'blog-cell-error';
            errEl.textContent = data.error;
            resultEl.appendChild(errEl);
        } else {
            const text = data.result || '';
            const count = data.count ?? '';
            const ms = elapsed != null ? `${elapsed}ms` : '';
            const meta = [count ? `${count} item${count !== 1 ? 's' : ''}` : '', ms].filter(Boolean).join(' in ');

            const header = document.createElement('div');
            header.className = 'blog-cell-result-header';
            header.innerHTML = `Out: <span class="blog-cell-result-meta">${escapeHtml(meta)}</span>`;
            resultEl.appendChild(header);

            const isXml = /^\s*</.test(text);
            const isJson = /^\s*[\[{]/.test(text);
            const mode = isXml ? 'xml' : isJson ? 'json' : null;

            if (mode && text.length < 50000) {
                const cm = document.createElement('jinn-codemirror');
                cm.className = 'blog-cell-output-cm';
                cm.setAttribute('mode', mode);
                cm.setAttribute('readonly', 'true');
                cm.setAttribute('code', text);
                resultEl.appendChild(cm);
            } else {
                const pre = document.createElement('pre');
                pre.className = 'blog-cell-output';
                pre.textContent = text;
                resultEl.appendChild(pre);
            }
        }
    }

    if (runBtn) {
        runBtn.addEventListener('click', async () => {
            const query = (editor && editor.content) ? editor.content : originalCode;
            const methodSelect = cell.querySelector('.blog-cell-method');
            const method = methodSelect ? methodSelect.value : (cell.dataset.method || 'adaptive');
            const indent = cell.dataset.indent === 'yes';

            runBtn.disabled = true;
            resultEl.style.display = 'block';
            resultEl.innerHTML = '<div class="blog-cell-result-header">Running\u2026</div>';
            if (resetBtn) resetBtn.style.display = '';

            const t0 = Date.now();
            try {
                const data = await runQuery(query, method, indent);
                showResult(data, Date.now() - t0);
            } catch (err) {
                resultEl.innerHTML =
                    '<div class="blog-cell-error">Could not connect to the query service.\n' +
                    'Make sure eXist-db is running.</div>';
            } finally {
                runBtn.disabled = false;
            }
        });
    }

    if (resetBtn) {
        resetBtn.addEventListener('click', () => {
            if (editor) {
                const setOrig = () => {
                    if (editor._editor) {
                        editor.content = originalCode;
                    } else {
                        requestAnimationFrame(setOrig);
                    }
                };
                requestAnimationFrame(setOrig);
            }
            resultEl.style.display = 'none';
            resultEl.innerHTML = '';
            resetBtn.style.display = 'none';
        });
    }
}

async function initBlogCells() {
    await customElements.whenDefined('jinn-codemirror');
    document.querySelectorAll('.blog-cell').forEach(initCell);
}

document.addEventListener('DOMContentLoaded', initBlogCells);
