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

  console.log "Creating #{projectName}/controllers/"
  fs.mkdir("#{projectName}/controllers")

  console.log "Creating #{projectName}/models/"
  fs.mkdir("#{projectName}/models")

  console.log "Creating #{projectName}/collections/"
  fs.mkdir("#{projectName}/collections")

  console.log "Creating #{projectName}/views/"
  fs.mkdir("#{projectName}/views")

  console.log "Creating #{projectName}/templates/"
  fs.mkdir("#{projectName}/templates")

  console.log "Copying #{__dirname}/../lib to #{projectName}/lib/"
  fs.copy("#{__dirname}/../lib/", "#{projectName}/lib")

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

  fileName = "controllers/#{controllerUnderscoreName}_controller"
  files.push fileName
  fs.writeFileSync("./#{fileName}.coffee", templates.controller(controllerName: controllerName, states: states))

  for state in states
    state = downcaseFirstChar(state)
    viewFileName = "views/#{controllerUnderscoreName}_#{_(state).underscored()}_view"
    files.push viewFileName
    fs.writeFileSync("./#{viewFileName}.coffee", templates.view(controllerName: controllerName, stateName: state))

    templateFileName = "templates/#{controllerUnderscoreName}_#{_(state).underscored()}"
    files.push templateFileName
    fs.writeFileSync("./#{templateFileName}.coffee", templates. viewTemplate(controllerName: controllerName, stateName: state))

  console.log "Compile this directory to javascript, then include the resulting files:"
  for file in files
    console.log("<script type=\"text/javascript\" src=\"#{file}.js\"/>")

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
  fileName = "controllers/#{_(modelName).underscored()}_controller"
  files.push fileName
  fs.writeFileSync("./#{fileName}.coffee", templates.crudController(modelName: modelName))

  # Views
  fileName = "views/#{modelName.toLowerCase()}_index"
  files.push fileName
  fs.writeFileSync("./#{fileName}.coffee", templates.indexView(modelName: modelName))

  console.log "Compile this directory to javascript, then include the resulting files:"
  for file in files
    console.log("<script type=\"text/javascript\" src=\"#{file}.js\"/>")

exports.compile = ->
  exec = require('child_process').exec
  exec("coffee -cj application.js .", ->
    console.log "Compiled CoffeeScript -> JS:"
    console.log "<script type=\"text/javascript\" src=\"application.js\"/>"
  )

# Returns true if current working directory is a backbone diorama project
isProjectDir = () ->
  expectedDirs = ['controllers', 'models', 'collections', 'views'] 
  foundDirs = fs.readdirSync('.').filter((n) ->
    if(expectedDirs.indexOf(n) == -1)
        return false
    return true
  )
  foundDirs.length == 4
