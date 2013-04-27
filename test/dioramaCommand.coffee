dioramaCommands = require("../src/dioramaCommand")
templates = require("../src/templates")
assert = require("assert")
fs = require('fs-extra')
exec = require('child_process').exec

describe('create a new project', ->
  before(->
    dioramaCommands.new('testProject')
  )

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
    expectedFiles = ['backbone-min.js', 'jquery-1.8.3.min.js', 'underscore-min.js', 'diorama.js', 'json2.js', 'handlebars.js']
    # Lack of synchronus copy means we have to wait for this to complete :-|
    setTimeout(->
      foundDirs = fs.readdirSync('testProject/js/lib').filter((n) ->
        if(expectedFiles.indexOf(n) == -1)
          return false
        return true
      )
      assert.equal(foundDirs.length, expectedFiles.length)
    ,500)
  )

  it("should have created a manifest file", ->
    expectedFiles = ['compile_manifest.json']
    # Lack of synchronus copy means we have to wait for this to complete :-|
    setTimeout(->
      foundDirs = fs.readdirSync('testProject/src/').filter((n) ->
        if(expectedFiles.indexOf(n) == -1)
          return false
        return true
      )
      assert.equal(foundDirs.length, expectedFiles.length)
    ,500)
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
        generated_template = fs.readFileSync('src/templates/post_index.hbs', 'utf8')
        assert.equal generated_template, expected_txt
      )

      it('creates a view file from template', ->
        expected_txt = templates.view(viewName: 'PostIndex')
        generated_view = fs.readFileSync('src/views/post_index_view.coffee', 'utf8')
        assert.equal generated_view, expected_txt
      )
      after(->
        fs.unlinkSync("#{process.cwd()}/src/templates/post_index.hbs")
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
        generated_template = fs.readFileSync('src/templates/post_index.hbs', 'utf8')
        assert.equal generated_template, expected_txt

        # Show
        expected_txt = templates.viewTemplate(controllerName: 'Post', viewName: 'show')
        generated_template = fs.readFileSync('src/templates/post_show.hbs', 'utf8')
        assert.equal generated_template, expected_txt
      )

      after(->
        fs.unlinkSync("#{process.cwd()}/src/controllers/post_controller.coffee")
        fs.unlinkSync("#{process.cwd()}/src/views/post_index_view.coffee")
        fs.unlinkSync("#{process.cwd()}/src/views/post_show_view.coffee")
        fs.unlinkSync("#{process.cwd()}/src/templates/post_index.hbs")
        fs.unlinkSync("#{process.cwd()}/src/templates/post_show.hbs")
      )
    )

    describe('diorama.generateNestedView', ->
      before(->
        dioramaCommands.generateNestingView 'PostIndex', 'PostRow'
      )
      it('generates the parent nesting view using the nesting template', ->
        expected_txt = templates.nestingView(name: 'PostIndex')
        generated_template = fs.readFileSync('src/views/post_index_view.coffee', 'utf8')
        assert.equal generated_template, expected_txt
      )
      it('generates a nesting view template using the nesting view template template', ->
        expected_txt = templates.nestingViewTemplate(name: 'PostIndex', childView: 'PostRow')
        generated_template = fs.readFileSync('src/templates/post_index.hbs', 'utf8')
        assert.equal generated_template, expected_txt
      )
      it('generates a child view and template using the view templates', ->
        expected_txt = templates.view(viewName: 'post_row')
        generated_template = fs.readFileSync('src/views/post_row_view.coffee', 'utf8')
        assert.equal generated_template, expected_txt

        expected_txt = templates.viewTemplate(viewName: 'post_row')
        generated_template = fs.readFileSync('src/templates/post_row.hbs', 'utf8')
        assert.equal generated_template, expected_txt
      )
    )
  )

  # Clean-up
  after( ->
    exec 'rm -r testProject/'
  )
)
