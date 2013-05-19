dioramaCommands = require("../src/dioramaCommand")
exec = require('child_process').exec

exports.createAndEnterProjectDir = (done)->
    dioramaCommands.new('testProject')
    setTimeout(->
      process.chdir('testProject/')
      done()
    , 200)

exports.teardownProject = ->
  # Clean-up
  after( ->
    exec 'rm -r testProject/'
    process.chdir('../')
  )
