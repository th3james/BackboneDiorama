helpers = require("#{__dirname}/../commandHelpers.coffee")
dioramaCommand = require("../dioramaCommand.coffee")

exports.help = ->
  helpers.printCommandHelpText('help')
  
  for commandName,command of dioramaCommand
    console.log "    * #{commandName}"
