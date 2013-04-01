fs = require('fs')

exports.help = ->
  console.log(fs.readFileSync("#{__dirname}/help.md", 'utf8'))
