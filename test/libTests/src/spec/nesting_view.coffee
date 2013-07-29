assert = chai.assert

suite 'Backbone.Diorama.NestingView'

test('when 2 nesting views exist, older views render in the correct context', ->
  viewToRender = new Backbone.Views.TestNestingParentView()
  newerView = new Backbone.Views.SecondNestingParentView()

  $('#test-container').append(viewToRender.render().el)

  assert.match($('#test-container > div').html(), /.*TestNestingParent.*/)
  assert.match($('#test-container > div').html(), /.*TestNestingChild.*/)

  viewToRender.close()
  $('#test-container').empty()
)


test('.generateSubViewPlaceholderTag adds a data-sub-view-cid attribute to the view.el', ->
  class TestSubView extends Backbone.View

  nestingView = new Backbone.Diorama.NestingView()
  subView = new TestSubView()
  html = nestingView.generateSubViewPlaceholderTag(subView).toString()

  viewElement = $.parseHTML(html)[0]
  
  assert.equal($(viewElement).attr('data-sub-view-cid'), subView.cid)
)

test('.generateSubViewPlaceholderTag respects the tagName attribute', ->
  class TestSubView extends Backbone.View
    tagName: 'section'

  nestingView = new Backbone.Diorama.NestingView()
  html = nestingView.generateSubViewPlaceholderTag(new TestSubView()).toString()
  
  viewElement = $.parseHTML(html)[0]

  assert.equal(viewElement.tagName, 'SECTION')
)

test('.generateSubViewPlaceholderTag respects the tagName attribute when it is a function', ->
  class TestSubView extends Backbone.View
    tagName: ->
      'section'

  nestingView = new Backbone.Diorama.NestingView()
  html = nestingView.generateSubViewPlaceholderTag(new TestSubView()).toString()
  
  viewElement = $.parseHTML(html)[0]

  assert.equal(viewElement.tagName, 'SECTION')
)

test('.generateSubViewPlaceholderTag respects the className attribute', ->
  class TestSubView extends Backbone.View
    className: 'someClass'

  nestingView = new Backbone.Diorama.NestingView()
  html = nestingView.generateSubViewPlaceholderTag(new TestSubView()).toString()
  
  viewElement = $.parseHTML(html)[0]

  assert.ok(
    $(viewElement).hasClass(TestSubView::className),
    "View element does not have the correct class attribute"
  )
)
