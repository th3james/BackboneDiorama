_ = require('underscore')
fs = require('fs')

exports.model = _.template(fs.readFileSync('./src/templates/model.jst', 'utf8'))
exports.collection = _.template(fs.readFileSync('./src/templates/collection.jst', 'utf8'))
exports.crud_controller = _.template(fs.readFileSync('./src/templates/crud_controller.jst', 'utf8'))
