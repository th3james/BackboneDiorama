# Commands available from the diorama command

_ = require('underscore')
fs = require('fs-extra')
templates = require('../src/templates.coffee')
# Underscore String plus exports
_.str = require('underscore.string')
_.mixin(_.str.exports())
helpers = require("#{__dirname}/commandHelpers.coffee")

commandFiles = _.reject(fs.readdirSync("#{__dirname}/commands/"), helpers.isNotCoffeeScriptFilename)
commandFiles = _.map(commandFiles, helpers.stripCoffeeExtension)

for commandFile in commandFiles
  exports[commandFile] = require("#{__dirname}/commands/#{commandFile}.coffee")[commandFile]
