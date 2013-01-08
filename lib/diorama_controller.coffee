# Controller that adds concept of action events bindings,
# which are event bindings that are only valid for the duration
# of an action
window.Backbone.Diorama ||= {}
class Backbone.Diorama.Controller
  _.extend @::, Backbone.Events

  # Add binding which is only valid for action duration.
  transitionToActionOn: (publisher, event, action) ->
    @actionEventBindings ||= []
    boundAction = () =>
      @transitionToAction(action, arguments)

    publisher.on(event, boundAction)
    @actionEventBindings.push(publisher: publisher, event: event, action: boundAction)

  # Clear event bindings for current action
  clearActionEventBindings: () ->
    _.each @actionEventBindings, (binding) ->
      binding.publisher.off(binding.event, binding.action)
    @actionEventBindings = []

  # Clean-up, and transition to the new action
  transitionToAction: (action, eventArguments) ->
    @clearActionEventBindings()
    action.apply(@, eventArguments)

