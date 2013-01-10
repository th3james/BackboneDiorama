_ = require('underscore')
fs = require('fs')

exports.model = _.template(fs.readFileSync("#{__dirname}/templates/model.jst", 'utf8'))
exports.collection = _.template(fs.readFileSync("#{__dirname}/templates/collection.jst", 'utf8'))
exports.crud_controller = _.template(fs.readFileSync("#{__dirname}/templates/crud_controller.jst", 'utf8'))
