window.Backbone ||= {}
window.Backbone.Views ||= {}

class Backbone.Views.MainShowView extends Backbone.View
  template: Handlebars.templates['main_show.hbs']

  initialize: (options) ->
    @render()

  render: ->
    @$el.html(@template())
    return @

  onClose: ->
    
