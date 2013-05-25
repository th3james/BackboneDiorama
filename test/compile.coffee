helpers = require('./testHelpers')
sinon = require('sinon')
dioramaCommands = require("../src/dioramaCommand")
assert = require("assert")
fs = require('fs')

describe 'inside a project', ->
  before (done) ->
    helpers.createAndEnterProjectDir(done)

  describe 'when the compile manifest is empty', ->

    describe 'dioramaCommand.compile', ->
      before ->
        sinon.spy(console, 'log')
        dioramaCommands.compile()

      it 'logs a message telling the user the manifest is empty', ->
        assert(console.log.calledWithMatch /src\/compile_manifest.json file is empty/)

      after ->
        console.log.restore()

  describe 'only handlebars templates are in the compile manifest', ->
    before ->
      template_text = "<h1>Hello World</h1>"
      fs.writeFileSync('src/templates/test.hbs', template_text)

      compile_manifest_text = "[\"templates/test\"]"
      fs.writeFileSync('src/compile_manifest.json', compile_manifest_text)

    describe 'dioramaCommand.compile', ->
      before (done)->
        dioramaCommands.compile()
        setTimeout(done, 200)

      it 'compiles to js/application.js', ->
        assert(fs.existsSync('js/application.js'))

    after ->
      fs.unlinkSync('src/compile_manifest.json')
      fs.unlinkSync('src/templates/test.hbs')

  after ->
    helpers.teardownProject()
