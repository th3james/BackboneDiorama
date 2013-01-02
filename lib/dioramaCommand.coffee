# Commands available from the diorama command
exports.help = ->
  console.log """
    Diorama usage:
      TODO - write this
  """

exports.new = (projectName) ->
  fs = require('fs')
  
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
