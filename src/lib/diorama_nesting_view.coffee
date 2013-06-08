window.Backbone ||= {}
window.Backbone.Views ||= {}

class Backbone.Diorama.NestingView extends Backbone.View
  constructor: ->
    Handlebars.registerHelper('addSubViewTo', @addSubViewTo)
    super

  addSubViewTo: (view, subViewName, options) =>
    @addSubView.call(view, subViewName, options)

  addSubView: (viewName, options) ->
    viewOptions = options.hash || {}

    View = Backbone.Views[viewName]
    view = new View(viewOptions)

    @subViews ||= []
    @subViews.push(view)

    return @generateSubViewPlaceholderTag(view)

  generateSubViewPlaceholderTag: (subView) ->
    html = "<#{subView.tagName} data-sub-view-cid=\"#{subView.cid}\"></#{subView.tagName}>"
    return new Handlebars.SafeString(html)

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
