window.Backbone ||= {}
window.Backbone.Views ||= {}

class Backbone.Views.TestNestingParentView extends Backbone.Diorama.NestingView
  template: Handlebars.templates['test_nesting_parent.hbs']

  initialize: (options) ->
    @once('close', @closeSubViews)
    @render()

  render: =>
    @$el.html(@template(thisView: @))
    @attachSubViews()

    return @
