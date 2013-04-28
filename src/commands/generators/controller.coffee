helpers = require("#{__dirname}/../../commandHelpers.coffee")
_ = helpers.requireUnderscoreWithStringHelpers

exports.controller = (controllerName, states...) ->
  unless controllerName?
    helpers.printCommandHelpText('generators/controller')
    return

  unless helpers.isProjectDir()
    console.log "#{process.cwd()} does not appear to be a Backbone Diorama project"
    return false

  unless controllerName?
    console.log "You must specify a controller name"
    return false

  controllerUnderscoreName = _(controllerName).underscored()
  console.log "controllerUnderscoreName: #{controllerUnderscoreName}"
  controllerName = _(helpers.downcaseFirstChar(controllerName)).camelize()
  console.log "controllerName: #{controllerName}"

  console.log "### Generating controller #{_(controllerName).classify()} ###"

  files = []

  files.push helpers.writeTemplate('controller', {controllerName: controllerName, states: states}, "controllers/#{controllerUnderscoreName}_controller")

  for state in states
    state = helpers.downcaseFirstChar(state)
    files.push helpers.writeTemplate('viewTemplate', {controllerName: controllerName, viewName: state}, "templates/#{controllerUnderscoreName}_#{_(state).underscored()}", "hbs")

    files.push helpers.writeTemplate('view', {controllerName: controllerName, viewName: state}, "views/#{controllerUnderscoreName}_#{_(state).underscored()}_view")

  for file in files
    console.log("Created #{file}")

  console.log "### Generated Controller Backbone.Controllers.#{_(controllerName).classify()}Controller ###"
  console.log "   include it in src/compile_manifest.json with: "
  console.log "\"#{files.join("\",\n\"")}\""
  console.log "   start it with: new Backbone.Controllers.#{_(controllerName).classify()}Controller()"

