suite 'Backbone.Diorama.NestingView'

test('when 2 nesting views exist, older views render in the correct context', ->
  viewToRender = new Backbone.Views.TestNestingParentView()
  newerView = new Backbone.Views.SecondNestingParentView()

  $('#test-container').append(viewToRender.render().el)

  expect($('#test-container > div').html()).to.match(/.*TestNestingParent.*/)
  expect($('#test-container > div').html()).to.match(/.*TestNestingChild.*/)

  viewToRender.close()
  $('#test-container').empty()
)

test('.generateSubViewPlaceholderTag respects the tagName attribute', ->
  class TestSubView
    tagName: 'section'

  nestingView = new Backbone.Diorama.NestingView()
  html = nestingView.generateSubViewPlaceholderTag(new TestSubView())
  
  expect(html).to.match(new RegExp(".*</#{TestSubView::tagName}>"))
)
