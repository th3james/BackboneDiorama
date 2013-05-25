fs = require('fs')
_  = require('underscore')
exec = require('child_process').exec
watcher = require('node-watch')

EMPTY_MANIFEST_MESSAGE = '### WARNING ###\n
Your src/compile_manifest.json file is empty, you need to populate it with the files you wish to be compiled, like this:\n
  "model/task",\n
  "collection/task"\n
\n
Pro-tip: when using generators, they will print out the required includes
\n
'

# Compile files in src/compile_manifest.json
exports.compile = (watch) ->

  concatenate()

  if watch?
    watcher('src/', (files)->
      concatenate()
    )

# Concatenate CS into one file
concatenate = ->
  files = JSON.parse(fs.readFileSync('src/compile_manifest.json', 'utf8'))

  if files.length == 0
   console.log EMPTY_MANIFEST_MESSAGE

  templateFiles = getTemplateFiles(files)
  appFiles = getNonTemplateFiles(files)

  console.log ""
  console.log "Compiling src files to js/application.js:"
  appContents = []
  remaining = appFiles.length
  if remaining > 0
    for file, index in appFiles then do (file, index) ->
      fs.readFile "src/#{file}.coffee", 'utf8', (err, fileContents) ->
        console.log "Failed to read coffeescript file: #{err}" if err
        appContents[index] = fileContents
        process(appContents, templateFiles) if --remaining is 0
  else
    processTemplates(templateFiles, false)

getTemplateFiles = (files) ->
  _.filter(files, (file) -> file.split("/")[0] == "templates" )

getNonTemplateFiles = (files) ->
  _.filter(files, (file) -> file.split("/")[0] != "templates" )

process = (appContents, templateFiles)->
  fs.appendFileSync 'application.coffee', appContents.join('\n\n'), 'utf8'
  exec 'coffee  --output js/ --compile application.coffee', (compileError, stdout, stderr) ->
    return console.log "###\n Unable to compile coffeescript, check ./application.coffee:\n\n#{compileError}###" if compileError

    console.log "  #{appContents.length} coffeescripts"
    processTemplates(templateFiles, true)

    fs.unlink 'application.coffee'

processTemplates = (templateFiles, concatenateToApplication = true) ->
  templateFiles = _.map(templateFiles, (file) -> "src/#{file}.hbs")

  return unless templateFiles.length > 0

  # Compile the handlebars to stdout to remove the need to write and
  # read an extra file
  exec "handlebars --min #{templateFiles.join(" ")}", (compileError, stdout, stderr) ->
    if stderr != ''
      console.log " ### Error compiling templates"
      console.log " ### #{stderr}"
      if stderr.match(/handlebars\: command not found/g)
        console.log "### Looks like handlebars isn't installed globally, install it with:"
        console.log "###  npm install -g handlebars"
    # Use readFile/writeFile to prepend the templates, otherwise
    # they won't be accessible to the Views
    fileContents = ''
    if concatenateToApplication
      fileContents = fs.readFileSync "js/application.js", 'utf8'

    fs.writeFileSync 'js/application.js', [stdout, fileContents].join("\n;\n")
    console.log "  #{templateFiles.length} templates"

