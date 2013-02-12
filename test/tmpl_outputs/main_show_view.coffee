window.Backbone ||= {}
window.Backbone.Views ||= {}

class Backbone.Views.MainShowView extends Backbone.View
  template: JST['main/show']

  initialize: (options) ->
    @render()

  render: ->
    @$el.html(@template())
    return @

  onClose: ->
    
