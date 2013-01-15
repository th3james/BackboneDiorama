# Controller that adds concept of state events bindings,
# which are event bindings that are only valid for the duration
# of an state
window.Backbone.Diorama ||= {}
class Backbone.Diorama.Controller
  _.extend @::, Backbone.Events

  # Creates event bindings for the current state, 
  # which transition to a specified newState on occurrence
  #
  # Takes an array of objects containing keys:
  #   publisher: object to observe
  #   event: event to listen for
  #   newState: the new state to transition to
  changeStateOn: (transitionBindings...) ->
    @stateEventBindings ||= []
    for transitionBinding in transitionBindings
      # Create a closured transition function to the new state
      boundTransition = (=>
        newState = transitionBinding.newState
        return =>
          @transitionToState(newState, arguments)
      )()

      transitionBinding.publisher.on(transitionBinding.event, boundTransition)
      @stateEventBindings.push(publisher: transitionBinding.publisher, event: transitionBinding.event, transition: boundTransition)

  # Clear event bindings for current state
  clearStateEventBindings: ->
    _.each @stateEventBindings, (binding) ->
      binding.publisher.off(binding.event, binding.transition)
    @stateEventBindings = []

  # Clear bindings and transition to the new state
  transitionToState: (state, eventArguments) ->
    @clearStateEventBindings()
    state.apply(@, eventArguments)

