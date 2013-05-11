helpers = require("#{__dirname}/../../commandHelpers.coffee")
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

  console.log "Generated #{_(modelName).classify()}Collection, add the following to your src/compile_manifest.json"
  console.log "\"#{files.join("\",\n\"")}\""

