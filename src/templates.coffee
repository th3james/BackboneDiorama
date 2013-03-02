_ = require('underscore')
fs = require('fs')
# Underscore String plus exports
_.str = require('underscore.string')
_.mixin(_.str.exports())

# This closure creates an underscore template function for
# the given file with _ included as default parameter
fileToTemplateWithUnderscore = (filename) ->
  tmpl = _.template(fs.readFileSync(filename, 'utf8'))

  return (variables)->
    tmpl(_.extend(variables, {_:_}))

exports.model = fileToTemplateWithUnderscore("#{__dirname}/templates/model.jst")
exports.collection = fileToTemplateWithUnderscore("#{__dirname}/templates/collection.jst")
exports.crudController = fileToTemplateWithUnderscore("#{__dirname}/templates/crud_controller.jst")
exports.indexView = fileToTemplateWithUnderscore("#{__dirname}/templates/index_view.jst")

exports.controller = fileToTemplateWithUnderscore("#{__dirname}/templates/controller.jst")
exports.view = fileToTemplateWithUnderscore("#{__dirname}/templates/view.jst")
exports.viewTemplate = fileToTemplateWithUnderscore("#{__dirname}/templates/view_template.jst")
exports.nestingView = fileToTemplateWithUnderscore("#{__dirname}/templates/nesting_view.jst")
exports.nestingViewTemplate = fileToTemplateWithUnderscore("#{__dirname}/templates/nesting_view_template.jst")
