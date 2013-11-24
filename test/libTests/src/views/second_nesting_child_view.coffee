window.Backbone ||= {}
window.Backbone.Views ||= {}

class Backbone.Views.SecondNestingChildView extends Backbone.View
  template: Handlebars.templates['second_nesting_child.hbs']

  initialize: (options) ->
    @render()

  render: ->
    @$el.html(@template())
    return @

