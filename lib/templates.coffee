_ = require('underscore')
fs = require('fs')

exports.model = _.template(fs.readFileSync('../lib/templates/model.jst', 'utf8'))
exports.collection = _.template(fs.readFileSync('../lib/templates/collection.jst', 'utf8'))
