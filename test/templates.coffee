templates = require('../src/templates.coffee')
assert = require("assert")
fs = require('fs-extra')
exec = require('child_process').exec

describe('model template', ->
  it('generates a basic model for given name', ->
    expected_txt = fs.readFileSync('test/tmpl_outputs/post_model.coffee', 'utf8')
    template_txt = templates.model(name: 'Post')
    assert.equal(template_txt, expected_txt)
  )
  # Clean-up
  after( ->
    exec 'rm -r testProject/'
  )
)
