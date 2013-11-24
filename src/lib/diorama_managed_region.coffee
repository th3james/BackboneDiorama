# Manages display and removal of multiple views which are switched between.
# It does this by storing a reference to the current view, then calling it's .close()
# function when another view is switched to
#
# Inspired by: http://lostechies.com/derickbailey/2011/09/15/zombies-run-managing-page-transitions-in-backbone-apps/
window.Backbone.Diorama ||= {}
class Backbone.Diorama.ManagedRegion
  constructor: (options) ->
    @tagName = (options.tagName if options?) || 'div'
    @$el = $("<#{@tagName}>")

  # Close the current view, render the given view into @element
  showView: (view) ->
    if (@currentView)
      @currentView.close()

    this.currentView = view
    this.currentView.render()

    @$el.html(this.currentView.el)

  # Returns true if element is empty
  isEmpty: () ->
    return @$el.is(':empty')

# Add 'close' event to Backbone.View
_.extend(Backbone.View::,
  # Clean up all bindings and remove elements from DOM
  close: ->
    if @onClose? and not @_functionIsBoundToEvent(@onClose, 'close')
      throw new Error(
        "onClose is no longer called automatically, please listenTo the view's 'close' event"
      )
    @trigger('close')
    @unbind()
    @remove()
  
  _functionIsBoundToEvent: (func, eventName) ->
    if @_events?
      for binding in @_events[eventName]
        if binding.callback is func
          return true

      return false
    else
      return false
)

