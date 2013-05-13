helpers = require("#{__dirname}/../../commandHelpers.coffee")
generateHelpers = require("#{__dirname}/../generateHelpers.coffee")
_ = helpers.requireUnderscoreWithStringHelpers

exports.collection = (modelName, generateModel) ->
  unless modelName?
    helpers.printCommandHelpText('generators/collection')
    return

  files = []
  modelName = _(modelName).underscored()

  if generateModel? and generateModel != 'false'
    files.push helpers.writeTemplate('model', {name: _(modelName).classify()}, "models/#{modelName}")

  files.push helpers.writeTemplate('collection', {modelName: _(modelName).classify()}, "collections/#{modelName}_collection")

  generateHelpers.printGeneratedClassInfo("Backbone.Collections.#{_(modelName).classify()}Collection", files)
