window.Backbone ||= {}
window.Backbone.Views ||= {}

class Backbone.Views.SecondNestingParentView extends Backbone.Diorama.NestingView
  template: Handlebars.templates['second_nesting_parent.hbs']

  initialize: (options) ->
    @once('close', @closeSubViews)
    @render()

  render: =>
    @$el.html(@template(thisView: @))
    @attachSubViews()

    return @
