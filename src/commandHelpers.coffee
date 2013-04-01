fs = require('fs')

exports.printCommandHelpText = (textName) ->
  console.log(fs.readFileSync("#{__dirname}/commands/#{textName}.md", 'utf8'))
