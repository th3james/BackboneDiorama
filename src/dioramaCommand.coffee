# Commands available from the diorama command

_ = require('underscore')
fs = require('fs-extra')
templates = require('../src/templates.coffee')
# Underscore String plus exports
_.str = require('underscore.string')
_.mixin(_.str.exports())

downcaseFirstChar = (string) ->
  return string.charAt(0).toLowerCase() + string.substring(1)

exports.help = ->
  console.log """
    Diorama usage:
      TODO - write this
  """

exports.new = (projectName) ->
  console.log "Creating a new project directory #{projectName}"
  fs.mkdir(projectName)
  fs.mkdir("#{projectName}/js")
  fs.mkdir("#{projectName}/src")

  console.log "Creating #{projectName}/src/controllers/"
  fs.mkdir("#{projectName}/src/controllers")

  console.log "Creating #{projectName}/src/models/"
  fs.mkdir("#{projectName}/src/models")

  console.log "Creating #{projectName}/src/collections/"
  fs.mkdir("#{projectName}/src/collections")

  console.log "Creating #{projectName}/src/views/"
  fs.mkdir("#{projectName}/src/views")

  console.log "Creating #{projectName}/src/templates/"
  fs.mkdir("#{projectName}/src/templates")

  console.log "Copying #{__dirname}/../lib to #{projectName}/js/lib/"
  fs.copy("#{__dirname}/../lib/", "#{projectName}/js/lib")

  console.log "Creating #{projectName}/index.html"
  fs.copy("#{__dirname}/../src/templates/index.html", "#{projectName}/index.html")

exports.generateController = (controllerName, states...) ->
  unless isProjectDir()
    console.log "#{process.cwd()} does not appear to be a Backbone Diorama project"
    return false

  unless controllerName?
    console.log "You must specify a controller name"
    return false

  controllerUnderscoreName = _(controllerName).underscored()
  console.log "controllerUnderscoreName: #{controllerUnderscoreName}"
  controllerName = _(downcaseFirstChar(controllerName)).camelize()
  console.log "controllerName: #{controllerName}"

  console.log "### Generating controller #{_(controllerName).classify()} ###"

  files = []

  fileName = "src/controllers/#{controllerUnderscoreName}_controller"
  files.push fileName
  fs.writeFileSync("./#{fileName}.coffee", templates.controller(controllerName: controllerName, states: states))

  for state in states
    state = downcaseFirstChar(state)
    viewFileName = "src/views/#{controllerUnderscoreName}_#{_(state).underscored()}_view"
    files.push viewFileName
    fs.writeFileSync("./#{viewFileName}.coffee", templates.view(controllerName: controllerName, viewName: state))

    templateFileName = "src/templates/#{controllerUnderscoreName}_#{_(state).underscored()}"
    files.push templateFileName
    fs.writeFileSync("./#{templateFileName}.coffee", templates. viewTemplate(controllerName: controllerName, viewName: state))

  for file in files
    console.log("Created #{file}")

  console.log "### Generated Controller Backbone.Controllers.#{_(controllerName).classify()}Controller ###"
  console.log "   start it with: new Backbone.Controllers.#{_(controllerName).classify()}Controller()"

exports.scaffold = (modelName, fields...) ->
  unless isProjectDir()
    console.log "#{process.cwd()} does not appear to be a Backbone Diorama project"
    return false

  unless modelName?
    console.log "You must specify a model name"
    return false

  modelName = downcaseFirstChar(_(modelName))
  console.log "### Generating scaffold for #{_(modelName).classify()} ###"

  files = []
  # Model
  fileName = "models/#{_(modelName).underscored()}"
  files.push fileName
  fs.writeFileSync("./#{fileName}.coffee", templates.model(name: _(modelName).classify()))

  # Collection
  fileName = "collections/#{_(modelName).underscored()}_collection"
  files.push fileName
  fs.writeFileSync("./#{fileName}.coffee", templates.collection(modelName: _(modelName).classify()))

  # Controller 
  fileName = "src/controllers/#{_(modelName).underscored()}_controller"
  files.push fileName
  fs.writeFileSync("./#{fileName}.coffee", templates.crudController(modelName: modelName))

  # Views
  fileName = "src/views/#{modelName.toLowerCase()}_index"
  files.push fileName
  fs.writeFileSync("./#{fileName}.coffee", templates.indexView(modelName: modelName))

  for file in files
    console.log("Created #{file}")

exports.generateView = (viewName) ->
  viewName = _(viewName).underscored()
  viewFileName = "src/views/#{viewName}_view"
  fs.writeFileSync("./#{viewFileName}.coffee", templates.view(viewName: viewName))

  templateFileName = "src/templates/#{_(viewName).underscored()}"
  fs.writeFileSync("./#{templateFileName}.coffee", templates. viewTemplate(viewName: viewName))


exports.compile = ->
  exec = require('child_process').exec
  command = "coffee --join js/application.js --compile src/"
  console.log "Compiling with '#{command}'"
  exec(command, (error, stdout, stderr)->
    if error?
      console.log stderr
    else
      console.log "Compiled CoffeeScript -> JS to js/application.js"
  )

# Returns true if current working directory is a backbone diorama project
isProjectDir = () ->
  expectedDirs = ['js', 'src']
  foundDirs = fs.readdirSync('.').filter((n) ->
    if(expectedDirs.indexOf(n) == -1)
        return false
    return true
  )
  foundDirs.length == expectedDirs.length
