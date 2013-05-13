helpers = require("#{__dirname}/../../commandHelpers.coffee")
generateHelpers = require("#{__dirname}/../generateHelpers.coffee")
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
  controllerName = _(helpers.downcaseFirstChar(controllerName)).camelize()

  files = []

  files.push helpers.writeTemplate('controller', {controllerName: controllerName, states: states}, "controllers/#{controllerUnderscoreName}_controller")

  for state in states
    state = helpers.downcaseFirstChar(state)
    files.push helpers.writeTemplate('viewTemplate', {controllerName: controllerName, viewName: state}, "templates/#{controllerUnderscoreName}_#{_(state).underscored()}", "hbs")

    files.push helpers.writeTemplate('view', {controllerName: controllerName, viewName: state}, "views/#{controllerUnderscoreName}_#{_(state).underscored()}_view")

  generateHelpers.printGeneratedClassInfo("Backbone.Controllers.#{_(controllerName).classify()}Controller", files)
