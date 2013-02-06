window.Backbone ||= {}
window.Backbone.Views ||= {}

class Backbone.Diorama.NestingView extends Backbone.View
  addSubView: (subView) ->
    @subViews ||= []
    @subViews.push(subView)
    
    return "<#{subView.tagName} data-sub-view-cid=\"#{subView.cid}\"></#{subView.tagName}"
   
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
