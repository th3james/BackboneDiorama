window.Backbone ||= {}
window.Backbone.Views ||= {}

class Backbone.Views.TestNestingChildView extends Backbone.View
  template: Handlebars.templates['test_nesting_child.hbs']

  initialize: (options) ->
    @render()

  render: ->
    @$el.html(@template())
    return @
