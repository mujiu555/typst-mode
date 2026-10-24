import { spawnSync } from 'node:child_process';
import { mkdtempSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import assert from 'node:assert/strict';

const output = mkdtempSync(join(tmpdir(), 'typst-mode-render-'));
function compile(name, source, expectedError) {
  const args = ['compile', '--root', '.', source ? '-' : 'tests/render/test.typ', join(output, `${name}.pdf`)];
  const result = spawnSync('typst', args, { input: source, encoding: 'utf8' });
  if (result.error) throw result.error;
  if (expectedError) {
    assert.notEqual(result.status, 0, `${name} unexpectedly compiled`);
    assert.match(result.stderr, expectedError);
  } else {
    assert.equal(result.status, 0, result.stderr);
    assert.equal(result.stderr, '', result.stderr);
  }
}
const preamble = '#import "/lib/_lib.typ/lib.typ": *\n';
compile('integration');
compile('single-author-rejected', preamble + '#meta(id: "a", title: [A], authors: [Alice])', /authors/);
compile('duplicate-label-rejected', preamble + '#mkindex("a", [First])\n#mkindex("a", [Second])', /duplicate label/);
compile('duplicate-document-rejected', preamble + '#meta(id: "a", title: [A], authors: ())\n#meta(id: "a", title: [B], authors: ())', /duplicate document id/);
compile('missing-label-rejected', preamble + '#lookup("missing", [Missing])', /missing/);
compile('empty-template', preamble + '#show: template\nNo metadata yet.\n#render-index()');
compile('missing-parent', preamble + '#show: template\n#meta(id: "a", parent_id: "absent", title: [A], authors: ())\n#mkheading(new-page: false)');
const query = spawnSync('typst', ['query', '--root', '.', 'tests/render/test.typ', 'heading'], { encoding: 'utf8' });
assert.equal(query.status, 0, query.stderr);
assert.equal(query.stderr, '');
assert.deepEqual(JSON.parse(query.stdout).map(h => h.level), [1, 2, 3, 3, 5, 1]);
console.log(`Rendering checks passed. PDFs: ${output}`);
