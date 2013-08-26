window.Backbone ||= {}
window.Backbone.Views ||= {}

class Backbone.Diorama.NestingView extends Backbone.View
  constructor: ->
    Handlebars.registerHelper('addSubViewTo', @addSubViewTo)
    super

  addSubViewTo: (view, subViewName, cacheKeyTemplate, options) =>
    if arguments.length == 3
      options = cacheKeyTemplate
      @addSubView.call(view, subViewName, options)
    else
      @addSubView.call(view, subViewName, cacheKeyTemplate, options)

  addSubView: (viewName, cacheKeyTemplate, options) ->
    if arguments.length == 2
      options = cacheKeyTemplate
      cacheKeyTemplate = null

    viewOptions = options.hash || {}

    if cacheKeyTemplate?
      compiledTemplate = Handlebars.compile(cacheKeyTemplate)
      cacheKey = compiledTemplate(viewOptions)
    else
      cacheKey = null

    @subViews ||= {}

    if @subViews[cacheKey]?
      view = @subViews[cacheKey]
    else
      View = Backbone.Views[viewName]
      view = new View(viewOptions)

      cacheKey ||= view.cid
      @subViews[cacheKey] = view

    return @generateSubViewPlaceholderTag(view, cacheKey)

  generateSubViewPlaceholderTag: (subView, cacheKey) ->
    el = subView.el
    $(el).attr('data-sub-view-key', cacheKey)
    return new Handlebars.SafeString(@htmlNodeToString(el))

  closeSubViewsWithoutPlaceholders: ->
    for key, subView of @subViews
      if @$el.find("[data-sub-view-key=\"#{key}\"]").length == 0
        # No placeholder found, close view
        subView.close()
        delete @subViews[key]

  attachSubViews: ->
    @dontShowRenderViewChangeMessage = true
    @closeSubViewsWithoutPlaceholders()
    if @subViews?
      for key, subView of @subViews
        subView.setElement(@$el.find("[data-sub-view-key=\"#{key}\"]"))

  renderSubViews: ->
    unless @dontShowRenderViewChangeMessage?
      error =  new Error("Diorama.NestingView.renderSubViews was called before attachSubViews! If
  you've just upgraded diorama, check out the changes to NestingView here: 
  http://gjigrhgdjhgdkj/")
      error.stack
      throw error
    for key, subView of @subViews
      subView.render()

  closeSubViews: ->
    if @subViews?
      for key, subView of @subViews
        subView.close()
      @subViews = {}


  htmlNodeToString: (node) ->
    tmpNode = document.createElement("div")
    tmpNode.appendChild node.cloneNode(true)
    str = tmpNode.innerHTML
    tmpNode = node = null # prevent memory leaks in IE
    str
