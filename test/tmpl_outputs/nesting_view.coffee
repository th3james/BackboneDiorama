window.Backbone ||= {}
window.Backbone.Views ||= {}

class Backbone.Views.PostIndexView extends Backbone.Diorama.NestingView
  template: JST['changes_index']

  initialize: (options) ->
    @render()

  render: =>
    @closeSubViews()
    @$el.html(@template(view: @, changeList: @changeList, speciesCount: @speciesList.length))
    @renderSubViews()

    return @

  onClose: ->
    @stopListening(@changeList, 'sync', @render)
    @stopListening(@speciesList)
    @closeSubViews()
