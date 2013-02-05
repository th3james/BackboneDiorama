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

  console.log "Adding coffeescript manifest #{projectName}/src/compile_manifest.json"
  fs.copy("#{__dirname}/../src/templates/compile_manifest.json", "#{projectName}/src/compile_manifest.json")

  console.log "Creating #{projectName}/index.html"
  fs.copy("#{__dirname}/../src/templates/index.html", "#{projectName}/index.html")

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
  files = []
  viewName = _(viewName).underscored()

  templateFileName = "templates/#{_(viewName).underscored()}"
  files.push templateFileName
  fs.writeFileSync("./src/#{templateFileName}.coffee", templates. viewTemplate(viewName: viewName))

  viewFileName = "views/#{viewName}_view"
  files.push viewFileName
  fs.writeFileSync("./src/#{viewFileName}.coffee", templates.view(viewName: viewName))

  console.log "Generated #{_(viewName).classify()}View, add the following to your src/compile_manifest.json"
  console.log "\"#{files.join("\",\n\"")}\""

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
      console.log "concatenating src/#{file}.coffee"
      fs.readFile "src/#{file}.coffee", 'utf8', (err, fileContents) ->
        throw err if err
        appContents[index] = fileContents
        process(appContents) if --remaining is 0

  # Compile 
  process = (appContents)->
    fs.writeFile 'application.coffee', appContents.join('\n\n'), 'utf8', (writeCoffeeError) ->
      throw writeCoffeeError if writeCoffeeError
      exec 'coffee  --output js/ --compile application.coffee', (compileError, stdout, stderr) ->
        throw compileError if compileError
        console.log stdout + stderr
        fs.unlink 'application.coffee', (removeCoffeeError) ->
          throw removeCoffeeError if removeCoffeeError
          console.log "compiled to js/application.js"
  
  if watch?
    watcher('src/', (files)->
      console.log 'hat'
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
