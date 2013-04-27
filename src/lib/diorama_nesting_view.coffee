window.Backbone ||= {}
window.Backbone.Views ||= {}

class Backbone.Diorama.NestingView extends Backbone.View
  constructor: ->
    Handlebars.registerHelper('subView', @viewHelper)
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

  viewHelper: (viewName, options) =>
    viewOptions = options.hash || {}

    View = Backbone.Views[viewName]
    view = new View(viewOptions)

    html = @addSubView(view)
    return new Handlebars.SafeString(html)
