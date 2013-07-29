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
    el = subView.el
    $(el).attr('data-sub-view-cid', subView.cid)
    return @htmlNodeToString(el)

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


  htmlNodeToString: (node) ->
    tmpNode = document.createElement("div")
    tmpNode.appendChild node.cloneNode(true)
    str = tmpNode.innerHTML
    tmpNode = node = null # prevent memory leaks in IE
    str
