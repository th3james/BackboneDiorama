helpers = require('./testHelpers')
dioramaCommands = require("../src/dioramaCommand")
assert = require("assert")

describe 'inside a project', ->
  before (done) ->
    helpers.createAndEnterProjectDir(done)

  describe 'when the compile manifest is empty', ->
    consoleLogSpy = null

    describe 'dioramaCommand.compile', ->
      before ->
        consoleLogSpy = (->
          _log = console.log
          lastMessage = null

          console.log = (message) ->
            lastMessage = message
            
            _log(lastMessage)

          restore = ->
            console.log = _log

          return {
            restore: restore
            lastMessage: ->
              return lastMessage
          }
        )()
          
        dioramaCommands.compile()

      it 'logs a message telling the user the manifest is empty', ->
        assert(consoleLogSpy.lastMessage().match /src\/compile_manifest.json file is empty/)

      after ->
        consoleLogSpy.restore()

  after ->
    helpers.teardownProject()
