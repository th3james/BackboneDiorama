window.Backbone ||= {}
window.Backbone.Views ||= {}

class Backbone.Views.IndexView extends Backbone.View
  template: JST['index']

  initialize: (options) ->
    @render()

  render: ->
    @$el.html(@template())
    return @

  onClose: ->
    
