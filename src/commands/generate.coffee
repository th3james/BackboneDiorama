fs = require('fs-extra')
helpers = require("#{__dirname}/../commandHelpers.coffee")
_ = helpers.requireUnderscoreWithStringHelpers

exports.generate = (commandName, options...) ->
  generatorFiles = _.reject(fs.readdirSync("#{__dirname}/../commands/generators/"), helpers.isNotCoffeeScriptFilename)
  generatorFiles = _.map(generatorFiles, helpers.stripCoffeeExtension)

  if !commandName? or _.indexOf(generatorFiles, commandName) < 0
    helpers.printCommandHelpText('generate')

    for command in generatorFiles
      console.log "    * #{command}"

    return

  generator = require("#{__dirname}/../commands/generators/#{commandName}.coffee")[commandName]
  generator.apply(this, options)
