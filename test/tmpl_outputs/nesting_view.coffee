window.Backbone ||= {}
window.Backbone.Views ||= {}

class Backbone.Views.PostIndexView extends Backbone.Diorama.NestingView
  template: Handlebars.templates['post_index.hbs']

  initialize: (options) ->
    @render()

  render: =>
    @$el.html(@template(thisView: @))
    @attachSubViews()

    return @

  onClose: ->
    @closeSubViews()
