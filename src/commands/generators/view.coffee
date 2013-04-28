helpers = require("#{__dirname}/../../commandHelpers.coffee")
_ = helpers.requireUnderscoreWithStringHelpers

exports.view = (viewName) ->
  unless viewName?
    helpers.printCommandHelpText('generators/view')
    return

  files = []
  viewName = _(viewName).underscored()

  files.push helpers.writeTemplate('viewTemplate', {viewName: viewName}, "templates/#{_(viewName).underscored()}", "hbs")

  files.push helpers.writeTemplate('view', {viewName: viewName}, "views/#{viewName}_view")

  console.log "Generated #{_(viewName).classify()}View, add the following to your src/compile_manifest.json"
  console.log "\"#{files.join("\",\n\"")}\""

