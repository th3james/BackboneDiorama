fs = require('fs')

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

