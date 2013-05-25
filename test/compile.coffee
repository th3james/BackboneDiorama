helpers = require('./testHelpers')
sinon = require('sinon')
dioramaCommands = require("../src/dioramaCommand")
assert = require("assert")

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

  after ->
    helpers.teardownProject()
