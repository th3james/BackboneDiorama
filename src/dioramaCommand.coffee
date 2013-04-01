# Commands available from the diorama command

_ = require('underscore')
fs = require('fs-extra')
templates = require('../src/templates.coffee')
# Underscore String plus exports
_.str = require('underscore.string')
_.mixin(_.str.exports())

downcaseFirstChar = (string) ->
  return string.charAt(0).toLowerCase() + string.substring(1)

isNotCoffeeScriptFilename = (fileName) ->
  tokens = fileName.split('.')
  return tokens[tokens.length-1] != 'coffee'

stripExtension = (fileName) ->
  tokens = fileName.split('.coffee')
  return tokens[0]

commandFiles = _.reject(fs.readdirSync("#{__dirname}/commands/"), isNotCoffeeScriptFilename)
commandFiles = _.map(commandFiles, stripExtension)

for commandFile in commandFiles
  exports[commandFile] = require("../src/commands/#{commandFile}.coffee")[commandFile]

# Helper to write templates to a file
# Expects a compile_manifest suitable filename, and returns it
writeTemplate = (templateName, templateArgs, fileName) ->
  fs.writeFileSync("./src/#{fileName}.coffee", templates[templateName](templateArgs))
  return fileName

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

  files.push writeTemplate('controller', {controllerName: controllerName, states: states}, "controllers/#{controllerUnderscoreName}_controller")

  for state in states
    state = downcaseFirstChar(state)
    files.push writeTemplate('viewTemplate', {controllerName: controllerName, viewName: state}, "templates/#{controllerUnderscoreName}_#{_(state).underscored()}")

    files.push writeTemplate('view', {controllerName: controllerName, viewName: state}, "views/#{controllerUnderscoreName}_#{_(state).underscored()}_view")

  for file in files
    console.log("Created #{file}")

  console.log "### Generated Controller Backbone.Controllers.#{_(controllerName).classify()}Controller ###"
  console.log "   include it in src/compile_manifest.json with: "
  console.log "\"#{files.join("\",\n\"")}\""
  console.log "   start it with: new Backbone.Controllers.#{_(controllerName).classify()}Controller()"

exports.generateNestingView = (parentViewName, childViewName) ->
  unless isProjectDir()
    console.log "#{process.cwd()} does not appear to be a Backbone Diorama project"
    return false

  unless parentViewName?
    console.log "You must specify a parent view"
    return false

  unless childViewName?
    console.log "You must specify a child view"
    return false

  parentViewUnderscoreName = _(parentViewName).underscored()
  parentViewName = _(downcaseFirstChar(parentViewName)).camelize()

  childViewUnderscoreName = _(childViewName).underscored()
  childViewName = _(downcaseFirstChar(childViewName)).camelize()

  console.log "### Generating parent view #{_(parentViewName).classify()} ###"

  files = []

  files.push writeTemplate('nestingViewTemplate', {name: parentViewName, childView: childViewName}, "templates/#{parentViewUnderscoreName}")
  files.push writeTemplate('nestingView', {name: parentViewName}, "views/#{parentViewUnderscoreName}_view")

  console.log "### Generating child view #{_(childViewName).classify()} ###"

  files.push writeTemplate('viewTemplate', {viewName: childViewName}, "templates/#{childViewUnderscoreName}")
  files.push writeTemplate('view', {viewName: childViewName}, "views/#{childViewUnderscoreName}_view")

  for file in files
    console.log("Created #{file}")

  console.log "### Generated nested view Backbone.Views.#{_(parentViewName).classify()}View ###"
  console.log "   include it in src/compile_manifest.json with: "
  console.log "\"#{files.join("\",\n\"")}\""

exports.generateView = (viewName) ->
  files = []
  viewName = _(viewName).underscored()

  files.push writeTemplate('viewTemplate', {viewName: viewName}, "templates/#{_(viewName).underscored()}")

  files.push writeTemplate('view', {viewName: viewName}, "views/#{viewName}_view")

  console.log "Generated #{_(viewName).classify()}View, add the following to your src/compile_manifest.json"
  console.log "\"#{files.join("\",\n\"")}\""

exports.generateCollection = (modelName, generateModel) ->
  files = []
  modelName = _(modelName).underscored()

  if generateModel? and generateModel != 'false'
    files.push writeTemplate('model', {name: _(modelName).classify()}, "models/#{modelName}")

  files.push writeTemplate('collection', {modelName: _(modelName).classify()}, "collections/#{modelName}_collection")

  console.log "Generated #{_(modelName).classify()}Collection, add the following to your src/compile_manifest.json"
  console.log "\"#{files.join("\",\n\"")}\""

exports.generateModel = (modelName) ->
  files = []
  modelName = _(modelName).underscored()

  files.push writeTemplate('model', {name: _(modelName).classify()}, "models/#{modelName}")

  console.log "Generated #{_(modelName).classify()} model, add the following to your src/compile_manifest.json"
  console.log "\"#{files.join("\",\n\"")}\""

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

# Compile files in src/compile_manifest.json
exports.compile = (watch) ->
  exec = require('child_process').exec
  watcher = require('node-watch');

  # Concatenate CS into one file
  concatenate = ->
    str = fs.readFileSync('src/compile_manifest.json', 'utf8')
    appFiles  = JSON.parse("#{str}")
    appContents = []
    remaining = appFiles.length
    for file, index in appFiles then do (file, index) ->
      fs.readFile "src/#{file}.coffee", 'utf8', (err, fileContents) ->
        console.log "Failed to read coffeescript file: #{err}" if err
        appContents[index] = fileContents
        process(appContents) if --remaining is 0

  # Compile 
  process = (appContents)->
    fs.writeFile 'application.coffee', appContents.join('\n\n'), 'utf8', (writeCoffeeError) ->
      return console.log "Failed to write concatenated coffee: #{writeCoffeeError}" if writeCoffeeError
      exec 'coffee  --output js/ --compile application.coffee', (compileError, stdout, stderr) ->
        return console.log "###\n Unable to compile coffeescript, check ./application.coffee:\n\n#{compileError}###" if compileError
        console.log stdout
        fs.unlink 'application.coffee', (removeCoffeeError) ->
          return console.log "couldn't clean up application.coffee file, you may delete it manually" if removeCoffeeError
          console.log "compiled to js/application.js"
  
  if watch?
    watcher('src/', (files)->
      concatenate()
    )
  else
    concatenate()

# Returns true if current working directory is a backbone diorama project
isProjectDir = () ->
  expectedDirs = ['js', 'src']
  foundDirs = fs.readdirSync('.').filter((n) ->
    if(expectedDirs.indexOf(n) == -1)
        return false
    return true
  )
  foundDirs.length == expectedDirs.length
