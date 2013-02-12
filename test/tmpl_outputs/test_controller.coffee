window.Backbone ||= {}
window.Backbone.Controllers ||= {}

class Backbone.Controllers.TestController extends Backbone.Diorama.Controller
  constructor: ->
    @mainRegion = new Backbone.Diorama.ManagedRegion()
    $('body').append(@mainRegion.$el)
    
    # Default state
    @index()


  index: =>
    indexView = new Backbone.Views.TestIndexView()
    @mainRegion.showView(indexView)

    ###
      @changeStateOn maps events published by other objects to
      controller states
    ###
    @changeStateOn(
    #  {event: 'someEvent', publisher: indexView, newState: @show}
    )

  show: =>
    showView = new Backbone.Views.TestShowView()
    @mainRegion.showView(showView)

    ###
      @changeStateOn maps events published by other objects to
      controller states
    ###
    @changeStateOn(
    #  {event: 'someEvent', publisher: showView, newState: @index}
    )

