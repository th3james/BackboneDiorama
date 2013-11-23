fs = require('fs-extra')
templates = require('../templates.coffee')
helpers = require("#{__dirname}/../commandHelpers.coffee")
sh = require('execSync')

exports.new = (projectName) ->
  unless projectName?
    helpers.printCommandHelpText('new')
    return

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

  console.log "Copying #{__dirname}/../../lib to #{projectName}/js/lib/"
  sh.run("cp -R #{__dirname}/../../lib #{projectName}/js/")

  console.log "Adding coffeescript manifest #{projectName}/src/compile_manifest.json"
  sh.run("cp #{__dirname}/../../src/templates/compile_manifest.json #{projectName}/src/compile_manifest.json")

  console.log "Creating #{projectName}/index.html"
  sh.run("cp #{__dirname}/../../src/templates/index.html #{projectName}/index.html")
