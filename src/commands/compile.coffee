fs = require('fs')
_  = require('underscore')

# Compile files in src/compile_manifest.json
exports.compile = (watch) ->
  exec = require('child_process').exec
  watcher = require('node-watch')

  # Concatenate CS into one file
  concatenate = ->
    files = JSON.parse(fs.readFileSync('src/compile_manifest.json', 'utf8'))

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
    exec "handlebars #{templateFiles.join(" ")}", (compileError, stdout, stderr) ->
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

  concatenate()

  if watch?
    watcher('src/', (files)->
      concatenate()
    )
