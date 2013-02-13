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
        exec "rm #{process.cwd()}/src/models/post.coffee"
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
          exec "rm #{process.cwd()}/src/collections/post_collection.coffee"
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
          exec "rm #{process.cwd()}/src/collections/post_collection.coffee"
        )
      )
    )
    after(->
      process.chdir('../')
    )
  )
  # Clean-up
  after( ->
    exec 'rm -r testProject/'
  )
)
