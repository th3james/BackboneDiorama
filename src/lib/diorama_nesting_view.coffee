window.Backbone ||= {}
window.Backbone.Views ||= {}

class Backbone.Diorama.NestingView extends Backbone.View
  constructor: ->
    @registerHandlebars(Handlebars)
    super

  addSubView: (subView) ->
    @subViews ||= []
    @subViews.push(subView)

    return "<#{subView.tagName} data-sub-view-cid=\"#{subView.cid}\"></#{subView.tagName}>"

  renderSubViews: ->
    if @subViews?
      for subView in @subViews
        subView.setElement(@$el.find("[data-sub-view-cid=\"#{subView.cid}\"]"))
        subView.render()

  closeSubViews: ->
    if @subViews?
      for subView in @subViews
        subView.onClose()
        subView.close()
    @subViews = []

  viewHelper: (context, options) =>
    viewName = context
    viewOptions = options.hash || {}

    if (_.isEmpty(viewOptions))
      viewOptions = _.clone(@)

    View = Backbone.Views[viewName]
    view = new View(viewOptions)

    @addSubView(view)

    html = @renderSubViews()
    return new Handlebars.SafeString(html)

  registerHandlebars: (Handlebars) ->
    Handlebars.registerHelper('view', @viewHelper)
