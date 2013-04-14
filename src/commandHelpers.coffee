fs = require('fs')
# Underscore String plus exports
_ = require('underscore')
_.str = require('underscore.string')
_.mixin(_.str.exports())

templates = require("#{__dirname}/templates.coffee")

exports.printCommandHelpText = (textName) ->
  console.log(fs.readFileSync("#{__dirname}/commands/#{textName}.md", 'utf8'))

exports.requireUnderscoreWithStringHelpers = _
  
# Helper to write templates to a file
# Expects a compile_manifest suitable filename, and returns it
exports.writeTemplate = (templateName, templateArgs, fileName, fileExtension) ->
  extension = fileExtension || 'coffee'
  fs.writeFileSync("./src/#{fileName}.#{extension}", templates[templateName](templateArgs))
  return fileName

# Returns true if current working directory is a backbone diorama project
exports.isProjectDir = () ->
  expectedDirs = ['js', 'src']
  foundDirs = fs.readdirSync('.').filter((n) ->
    if(expectedDirs.indexOf(n) == -1)
        return false
    return true
  )
  foundDirs.length == expectedDirs.length

exports.downcaseFirstChar = (string) ->
  return string.charAt(0).toLowerCase() + string.substring(1)

