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

# Augment backbone view to add binding management and close method
# Inspired by http://stackoverflow.com/questions/7567404/backbone-js-repopulate-or-recreate-the-view/7607853#7607853
_.extend(Backbone.View.prototype, 

  # Use instead of bind, creates a bind and stores the binding in @bindings
  bindTo: (model, ev, callback) ->
    model.bind(ev, callback, this)

    @bindings = [] unless @bindings?
    @bindings.push({ model: model, ev: ev, callback: callback })

  # Unbinds all the bindings in @bindings
  unbindFromAll: () ->
    if @bindings?
      _.each(@bindings, (binding) ->
        binding.model.unbind(binding.ev, binding.callback))
    @bindings = []

  # Clean up all bindings and remove elements from DOM
  close: () ->
    @unbindFromAll()
    @unbind()
    @remove()
    @onClose() if @onClose # Some views have specific things to clean up
)
