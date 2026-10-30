import { mkdtempSync, mkdirSync, readdirSync, readFileSync, symlinkSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { dirname, join, relative, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { spawnSync } from 'node:child_process';
import assert from 'node:assert/strict';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const output = mkdtempSync(join(tmpdir(), 'tysty-tests-'));
// Resolve the requested package name to this checkout without modifying the
// user's installed package or relying on a stale global package cache.
const packages = join(output, 'packages');
mkdirSync(join(packages, 'local', 'tysty'), { recursive: true });
symlinkSync(root, join(packages, 'local', 'tysty', '0.1.0'), 'dir');
const expectedErrors = JSON.parse(readFileSync(join(root, 'tests', 'reject.json'), 'utf8'));
const filters = process.argv.slice(2);
function files(dir) {
  return readdirSync(dir, { withFileTypes: true }).flatMap(entry => {
    const path = join(dir, entry.name);
    return entry.isDirectory() ? files(path) : path.endsWith('.typ') ? [path] : [];
  });
}
function formats(path) {
  if (['render/ssg.typ', 'render/ssg_ref.typ', 'render/html_bundle.typ', 'render/auto_bundle.typ'].includes(path)) return ['bundle'];
  if (['render/html_single.typ', 'render/ssg_html.typ'].includes(path)) return ['html'];
  if (['render/auto.typ', 'api/entry.typ'].includes(path)) return ['pdf', 'html'];
  return ['pdf'];
}
let passed = 0;
let failed = 0;
function verifyOutput(path, format, destination) {
  const contains = (file, value) => assert(readFileSync(file, 'utf8').includes(value), `${file} must contain ${JSON.stringify(value)}`);
  if (path === 'api/entry.typ' && format === 'html') {
    contains(destination, 'href="https://example.com/notes/child.typ"');
  }
  if (path === 'render/ssg.typ') {
    for (const [page, css] of [['index.html', 'tysty.css'], ['research/index.html', '../tysty.css'], ['research/review/index.html', '../../tysty.css']]) {
      contains(join(destination, page), `href="${css}"`);
    }
    contains(join(destination, 'research/index.html'), 'Research questions');
    contains(join(destination, 'research/index.html'), 'class="tysty-section-list"');
    contains(join(destination, 'research/index.html'), 'href="review/index.html"');
    assert(readFileSync(join(destination, 'tysty.css'), 'utf8').length > 0);
  }
  if (path === 'render/ssg_ref.typ') {
    for (const page of ['index.html', 'snippet/index.html']) contains(join(destination, page), 'SHARED-SNIPPET-BODY');
    contains(join(destination, 'index.html'), 'href="snippet/index.html"');
  }
  if (path === 'render/auto_bundle.typ') {
    contains(join(destination, 'index.html'), 'print.pdf#');
    assert(readFileSync(join(destination, 'print.pdf')).subarray(0, 5).equals(Buffer.from('%PDF-')));
  }
}
for (const input of files(join(root, 'tests')).sort()) {
  const path = relative(join(root, 'tests'), input);
  if (path.startsWith('fixtures/') || (filters.length && !filters.some(filter => path.includes(filter)))) continue;
  for (const format of formats(path)) {
    const destination = join(output, path.replaceAll('/', '-').replace(/\.typ$/, '.' + format));
    const args = ['compile', '--root', root, '--package-path', packages, '--features', 'html,bundle', '--format', format, '--diagnostic-format', 'short', input, destination];
    const result = spawnSync('typst', args, { cwd: root, encoding: 'utf8', timeout: 60000 });
    const diagnostic = (result.stderr ?? '') + (result.stdout ?? '');
    const expected = expectedErrors[path];
    if (path.startsWith('reject/') && !expected) throw new Error(`Missing expected diagnostic: ${path}`);
    if (result.error) throw result.error;
    let ok = expected
      ? result.status !== 0 && diagnostic.includes(expected) && !diagnostic.includes('TEST FAILURE:')
      : result.status === 0;
    let outputError;
    if (ok && !expected) {
      try { verifyOutput(path, format, destination); }
      catch (error) { ok = false; outputError = error.message; }
    }
    if (ok) {
      passed++;
    } else {
      failed++;
      console.error(`FAIL ${path} (${format})${expected ? `: expected ${JSON.stringify(expected)}` : ''}\n${outputError ?? diagnostic}`);
    }
  }
}
if (passed + failed === 0) throw new Error('No matching tests');
console.log(`${passed} passed, ${failed} failed. Outputs: ${output}`);
process.exitCode = failed ? 1 : 0;
