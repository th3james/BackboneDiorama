window.Backbone ||= {}
window.Backbone.Views ||= {}

class Backbone.Views.PostIndexView extends Backbone.Diorama.NestingView
  template: Handlebars.templates['post_index.hbs']

  initialize: (options) ->
    @render()

  render: =>
    @closeSubViews()
    @$el.html(@template(thisView: @))
    @renderSubViews()

    return @

  onClose: ->
    @closeSubViews()
