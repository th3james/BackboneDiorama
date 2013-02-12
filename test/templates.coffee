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
)

describe('collection template', ->
  it('generates a basic collection for given modeln name', ->
    expected_txt = fs.readFileSync('test/tmpl_outputs/post_collection.coffee', 'utf8')
    template_txt = templates.collection(modelName: 'Post')
    assert.equal(template_txt, expected_txt)
  )
)

describe('controller template', ->
  it('generates a controller with the given actions', ->
    expected_txt = fs.readFileSync('test/tmpl_outputs/test_controller.coffee', 'utf8')
    template_txt = templates.controller(controllerName: 'test', states: ['index', 'show'])
    #fs.writeFileSync('expected.coffee', expected_txt)
    #fs.writeFileSync('template.coffee', template_txt)
    assert.equal(template_txt, expected_txt)
  )
)

describe('view template', ->
  it('generates a view with the given name', ->
    expected_txt = fs.readFileSync('test/tmpl_outputs/index_view.coffee', 'utf8')
    template_txt = templates.view(viewName: 'index')
    #fs.writeFileSync('expected.coffee', expected_txt)
    #fs.writeFileSync('template.coffee', template_txt)
    assert.equal(template_txt, expected_txt)
  )
  it('generates a view with the given name and parent controller', ->
    assert false
  )
)
