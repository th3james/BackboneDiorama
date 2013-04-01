fs = require('fs-extra')
templates = require('../templates.coffee')

exports.new = (projectName) ->
  console.log "Creating a new project directory #{projectName}"
  fs.mkdirSync(projectName)
  fs.mkdirSync("#{projectName}/js")
  fs.mkdirSync("#{projectName}/src")

  console.log "Creating #{projectName}/src/controllers/"
  fs.mkdirSync("#{projectName}/src/controllers")

  console.log "Creating #{projectName}/src/models/"
  fs.mkdirSync("#{projectName}/src/models")

  console.log "Creating #{projectName}/src/collections/"
  fs.mkdirSync("#{projectName}/src/collections")

  console.log "Creating #{projectName}/src/views/"
  fs.mkdirSync("#{projectName}/src/views")

  console.log "Creating #{projectName}/src/templates/"
  fs.mkdirSync("#{projectName}/src/templates")

  console.log "Copying #{__dirname}/../lib to #{projectName}/js/lib/"
  fs.copy("#{__dirname}/../lib/", "#{projectName}/js/lib")

  console.log "Adding coffeescript manifest #{projectName}/src/compile_manifest.json"
  fs.copy("#{__dirname}/../src/templates/compile_manifest.json", "#{projectName}/src/compile_manifest.json")

  console.log "Creating #{projectName}/index.html"
  fs.copy("#{__dirname}/../src/templates/index.html", "#{projectName}/index.html")
