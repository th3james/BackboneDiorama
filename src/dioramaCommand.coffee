# Commands available from the diorama command

_ = require('underscore')
fs = require('fs-extra')
templates = require('../src/templates.coffee')
# Underscore String plus exports
_.str = require('underscore.string')
_.mixin(_.str.exports())

isNotCoffeeScriptFilename = (fileName) ->
  tokens = fileName.split('.')
  return tokens[tokens.length-1] != 'coffee'

stripExtension = (fileName) ->
  tokens = fileName.split('.coffee')
  return tokens[0]

commandFiles = _.reject(fs.readdirSync("#{__dirname}/commands/"), isNotCoffeeScriptFilename)
commandFiles = _.map(commandFiles, stripExtension)

for commandFile in commandFiles
  exports[commandFile] = require("../src/commands/#{commandFile}.coffee")[commandFile]
