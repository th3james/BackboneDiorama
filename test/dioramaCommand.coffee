dioramaCommands = require("../src/dioramaCommand")
templates = require("../src/templates")
assert = require("assert")
fs = require('fs-extra')
exec = require('child_process').exec

describe('create a new project', ->
  dioramaCommands.new('testProject')
  it('should create all the correct directories', ->
    expectedDirs = ['js', 'src']
    foundDirs = fs.readdirSync('testProject/').filter((n) ->
      if(expectedDirs.indexOf(n) == -1)
        return false
      return true
    )
    assert.equal(foundDirs.length, expectedDirs.length)
  )
  it("should have copied libs across", ->
    expectedFiles = ['backbone-min.js', 'jquery-1.8.3.min.js', 'underscore-min.js', 'diorama.js', 'json2.js']
    foundDirs = fs.readdirSync('testProject/js/lib').filter((n) ->
      if(expectedFiles.indexOf(n) == -1)
        return false
      return true
    )
    assert.equal(foundDirs.length, expectedFiles.length)
  )
  it("should have created a manifest file", ->
    expectedFiles = ['compile_manifest.json']
    foundDirs = fs.readdirSync('testProject/src/').filter((n) ->
      if(expectedFiles.indexOf(n) == -1)
        return false
      return true
    )
    assert.equal(foundDirs.length, expectedFiles.length)
  )
  describe('and inside the new project dir', ->
    before(->
      process.chdir('testProject/')
    )
    describe('dioramaCommand.generateModel', ->
      before(->
        dioramaCommands.generateModel 'post'
      )
      it('should call the create a model file from a template', ->
        expected_txt = templates.model(name: 'Post')
        generated_model = fs.readFileSync('src/models/post.coffee', 'utf8')
        assert.equal generated_model, expected_txt
      )
      after(->
        fs.unlinkSync("#{process.cwd()}/src/models/post.coffee")
      )
    )
    describe('dioramaCommand.generateCollection', ->
      describe('when run with generateModel false', ->
        before(->
          dioramaCommands.generateCollection 'post', 'false'
        )
        it('creates a collection file from template', ->
          expected_txt = templates.collection(modelName: 'Post')
          generated_collection = fs.readFileSync('src/collections/post_collection.coffee', 'utf8')
          assert.equal generated_collection, expected_txt
        )
        it('does not generate a model', ->
          assert(!fs.existsSync('src/models/post.coffee'))
        )
        after(->
          fs.unlinkSync("#{process.cwd()}/src/collections/post_collection.coffee")
        )
      )
      describe('when run with generateModel true', ->
        before(->
          dioramaCommands.generateCollection 'post', 'true'
        )
        it('creates a collection file from template', ->
          expected_txt = templates.collection(modelName: 'Post')
          generated_collection = fs.readFileSync('src/collections/post_collection.coffee', 'utf8')
          assert.equal generated_collection, expected_txt
        )
        it('creates a model file from template', ->
          expected_txt = templates.model(name: 'Post')
          generated_model = fs.readFileSync('src/models/post.coffee', 'utf8')
          assert.equal generated_model, expected_txt
        )
        after(->
          fs.unlinkSync("#{process.cwd()}/src/collections/post_collection.coffee")
          fs.unlinkSync("#{process.cwd()}/src/models/post.coffee")
        )
      )
    )
    describe('dioramaCommand.generateView', ->
      before(->
        dioramaCommands.generateView 'Post_index'
      )
      it('creates a template file from template', ->
        expected_txt = templates.viewTemplate(viewName: 'PostIndex')
        generated_template = fs.readFileSync('src/templates/post_index.coffee', 'utf8')
        assert.equal generated_template, expected_txt
      )
      it('creates a view file from template', ->
        expected_txt = templates.view(viewName: 'PostIndex')
        generated_view = fs.readFileSync('src/views/post_index_view.coffee', 'utf8')
        assert.equal generated_view, expected_txt
      )
      after(->
        fs.unlinkSync("#{process.cwd()}/src/templates/post_index.coffee")
        fs.unlinkSync("#{process.cwd()}/src/views/post_index_view.coffee")
      )
    )
    after(->
      process.chdir('../')
    )
    describe('dioramaCommand.generateController', ->
      before(->
        dioramaCommands.generateController 'Post', 'index', 'show'
      )
      it('generates a controller with the expected actions', ->
        expected_txt = templates.controller(controllerName: 'Post', states: ['index', 'show'])
        generated_template = fs.readFileSync('src/controllers/post_controller.coffee', 'utf8')
        assert.equal generated_template, expected_txt
      )
      it('generates a view for each of the given actions', ->
        # Index
        expected_txt = templates.view(controllerName: 'Post', viewName: 'index')
        generated_template = fs.readFileSync('src/views/post_index_view.coffee', 'utf8')
        assert.equal generated_template, expected_txt

        # Show
        expected_txt = templates.view(controllerName: 'Post', viewName: 'show')
        generated_template = fs.readFileSync('src/views/post_show_view.coffee', 'utf8')
        assert.equal generated_template, expected_txt
      )
      it('generates templates for each of the generated views', ->
        # Index
        expected_txt = templates.viewTemplate(controllerName: 'Post', viewName: 'index')
        generated_template = fs.readFileSync('src/templates/post_index.coffee', 'utf8')
        assert.equal generated_template, expected_txt

        # Show
        expected_txt = templates.viewTemplate(controllerName: 'Post', viewName: 'show')
        generated_template = fs.readFileSync('src/templates/post_show.coffee', 'utf8')
        assert.equal generated_template, expected_txt
      )
    )
    describe('diorama.generateNestedView', ->
      it('generates the parent nesting view using the nested template', ->
        assert false
      )
      it('generates a nested view template using the nested view template template', ->
        assert false
      )
      it('generates a child view and template using the view templates', ->
        assert false
      )
    )
  )
  # Clean-up
  after( ->
    exec 'rm -r testProject/'
  )
)
