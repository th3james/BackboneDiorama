helpers = require("#{__dirname}/../../commandHelpers.coffee")
_ = helpers.requireUnderscoreWithStringHelpers

exports.nestingView = (parentViewName, childViewName) ->
  unless parentViewName?
    helpers.printCommandHelpText('generators/nestingView')
    return

  unless helpers.isProjectDir()
    console.log "#{process.cwd()} does not appear to be a Backbone Diorama project"
    return false

  unless childViewName?
    console.log "You must specify a child view"
    return false

  parentViewUnderscoreName = _(parentViewName).underscored()
  parentViewName = _(helpers.downcaseFirstChar(parentViewName)).camelize()

  childViewUnderscoreName = _(childViewName).underscored()
  childViewName = _(helpers.downcaseFirstChar(childViewName)).camelize()

  console.log "### Generating parent view #{_(parentViewName).classify()} ###"

  files = []

  files.push helpers.writeTemplate('nestingViewTemplate', {name: parentViewName, childView: childViewName}, "templates/#{parentViewUnderscoreName}", "hbs")
  files.push helpers.writeTemplate('nestingView', {name: parentViewName}, "views/#{parentViewUnderscoreName}_view")

  console.log "### Generating child view #{_(childViewName).classify()} ###"

  files.push helpers.writeTemplate('viewTemplate', {viewName: childViewName}, "templates/#{childViewUnderscoreName}", "hbs")
  files.push helpers.writeTemplate('view', {viewName: childViewName}, "views/#{childViewUnderscoreName}_view")

  for file in files
    console.log("Created #{file}")

  console.log "### Generated nested view Backbone.Views.#{_(parentViewName).classify()}View ###"
  console.log "   include it in src/compile_manifest.json with: "
  console.log "\"#{files.join("\",\n\"")}\""

