#!/usr/bin/env node
// Dependency-free runner. Only newly generated temporary files are removed.
import { spawnSync } from 'node:child_process';
import { mkdtempSync, readdirSync, readFileSync, rmSync } from 'node:fs';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const dir = dirname(fileURLToPath(import.meta.url));
const root = resolve(dir, '..');
const tests = join(root, 'tests');
const temp = mkdtempSync(join(dir, '.run-'));
const strict = process.argv.includes('--strict');
const filter = process.argv.find(arg => arg.startsWith('--filter='))?.slice(9);
let pass = 0, fail = 0, known = 0;
function run(name, input, { error, bug } = {}) {
  if (filter && !name.includes(filter)) return;
  const stem = name.replaceAll('/', '--');
  const result = spawnSync(process.env.TYPST || 'typst', ['compile', '--root', root, input, join(temp, stem + '.pdf')], {
    encoding: 'utf8', timeout: 30000, maxBuffer: 4 * 1024 * 1024,
  });
  const diagnostic = (result.stderr || '') + (result.error?.message || '');
  const infrastructureFailure = result.error || result.signal || /failed to download|package not found|unknown font family|layout did not converge/.test(diagnostic);
  const ok = !infrastructureFailure && (error ? result.status !== 0 && diagnostic.includes(error) : result.status === 0);
  if (bug && !ok && !infrastructureFailure && diagnostic.includes(bug)) {
    known++;
    console.log(`XFAIL ${name}`);
  } else if (ok) {
    pass++;
    console.log(`${bug ? 'XPASS' : 'PASS '} ${name}`);
    // A fixed bug must be removed from the expected-failure list.
    if (bug) fail++;
  } else {
    fail++;
    console.error(`FAIL  ${name}\n${diagnostic}`);
  }
}
function discover(directory, relative = '') {
  return readdirSync(directory, { withFileTypes: true }).sort((a, b) => a.name.localeCompare(b.name)).flatMap(entry => {
    if (entry.name.startsWith('.')) return [];
    const name = relative + entry.name;
    return entry.isDirectory() ? discover(join(directory, entry.name), name + '/') : entry.name.endsWith('.typ') ? [name] : [];
  });
}
try {
  for (const file of discover(tests)) {
    const source = readFileSync(join(tests, file), 'utf8');
    const error = source.match(/^\/\/ expect-error: (.+)$/m)?.[1];
    const bug = source.match(/^\/\/ expect-failure: (.+)$/m)?.[1];
    if (error && bug) throw new Error(`Conflicting expectations: ${file}`);
    if (file.startsWith('reject/') && !error) throw new Error(`Missing expect-error directive: ${file}`);
    run(file.slice(0, -4), join(tests, file), { error, bug });
  }
} finally {
  rmSync(temp, { recursive: true, force: true });
}
if (pass + known + fail === 0) {
  console.error('No tests matched the filter.');
  fail++;
}
console.log(`\n${pass} passed, ${known} known failures, ${fail} unexpected results`);
process.exitCode = fail || (strict && known) ? 1 : 0;
