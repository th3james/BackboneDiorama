helpers = require("#{__dirname}/../../commandHelpers.coffee")
generateHelpers = require("#{__dirname}/../generateHelpers.coffee")
_ = helpers.requireUnderscoreWithStringHelpers

exports.model = (modelName) ->
  unless modelName?
    helpers.printCommandHelpText('generators/model')
    return

  files = []
  modelName = _(modelName).underscored()

  files.push helpers.writeTemplate('model', {name: _(modelName).classify()}, "models/#{modelName}")

  generateHelpers.printGeneratedClassInfo("Backbone.Models.#{_(modelName).classify()}", files)
