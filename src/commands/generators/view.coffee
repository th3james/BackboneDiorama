helpers = require("#{__dirname}/../../commandHelpers.coffee")
generateHelpers = require("#{__dirname}/../generateHelpers.coffee")
_ = helpers.requireUnderscoreWithStringHelpers

exports.view = (viewName) ->
  unless viewName?
    helpers.printCommandHelpText('generators/view')
    return

  files = []
  viewName = _(viewName).underscored()

  files.push helpers.writeTemplate('viewTemplate', {viewName: viewName}, "templates/#{_(viewName).underscored()}", "hbs")

  files.push helpers.writeTemplate('view', {viewName: viewName}, "views/#{viewName}_view")

  generateHelpers.printGeneratedClassInfo("Backbone.Views.#{_(viewName).classify()}View", files)
