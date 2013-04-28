helpers = require("#{__dirname}/../../commandHelpers.coffee")
_ = helpers.requireUnderscoreWithStringHelpers

exports.model = (modelName) ->
  unless modelName?
    helpers.printCommandHelpText('generators/model')
    return

  files = []
  console.log _
  modelName = _(modelName).underscored()

  files.push helpers.writeTemplate('model', {name: _(modelName).classify()}, "models/#{modelName}")

  console.log "Generated #{_(modelName).classify()} model, add the following to your src/compile_manifest.json"
  console.log "\"#{files.join("\",\n\"")}\""

