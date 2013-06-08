window.Backbone ||= {}
window.Backbone.Views ||= {}

class Backbone.Views.SecondNestingParentView extends Backbone.Diorama.NestingView
  template: Handlebars.templates['second_nesting_parent.hbs']

  initialize: (options) ->
    @render()

  render: =>
    @closeSubViews()
    @$el.html(@template(thisView: @))
    @renderSubViews()

    return @

  onClose: ->
    @closeSubViews()
