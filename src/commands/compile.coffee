fs = require('fs')
_  = require('underscore')

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
  exec = require('child_process').exec
  watcher = require('node-watch')

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

  appContents = []
  remaining = appFiles.length
  for file, index in appFiles then do (file, index) ->
    fs.readFile "src/#{file}.coffee", 'utf8', (err, fileContents) ->
      console.log "Failed to read coffeescript file: #{err}" if err
      appContents[index] = fileContents
      process(appContents, templateFiles) if --remaining is 0

getTemplateFiles = (files) ->
  _.filter(files, (file) -> file.split("/")[0] == "templates" )

getNonTemplateFiles = (files) ->
  _.filter(files, (file) -> file.split("/")[0] != "templates" )

process = (appContents, templateFiles)->
  fs.appendFileSync 'application.coffee', appContents.join('\n\n'), 'utf8'
  exec 'coffee  --output js/ --compile application.coffee', (compileError, stdout, stderr) ->
    return console.log "###\n Unable to compile coffeescript, check ./application.coffee:\n\n#{compileError}###" if compileError

    processTemplates(templateFiles)

    fs.unlink 'application.coffee', ->
      console.log "compiled to js/application.js"

processTemplates = (templateFiles) ->
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
    fs.readFile "js/application.js", 'utf8', (err, fileContents) ->
      return console.log "###\n Unable to read application.js when compiling templates" if err

      fs.writeFile 'js/application.js', [stdout, fileContents].join("\n\n"), (err) ->
        return console.log "###\n Unable to append handlebars templates" if err
