_ = require('underscore')
fs = require('fs')

exports.model = _.template(fs.readFileSync('../lib/templates/model.jst', 'utf8'))
