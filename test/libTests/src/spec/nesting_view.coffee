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

test('When using a addSubViewTo tag with a cache key,
  calling render again on the parent view does not re-render the child,
  but the child remains visible', ->
  subViewRenderCount = 0
  class CommentView extends Backbone.View
    id: 'comment-view'

    render: ->
      subViewRenderCount = subViewRenderCount + 1
      @$el.html("render count: #{subViewRenderCount}")

  class PostView extends Backbone.Diorama.NestingView
    template:
      Handlebars.compile("
        <h1>PostView</h1>
        {{addSubViewTo thisView 'TestSubView' 'comment-view-{{model.cid}}' model=comment}}
      ")

    initialize: ->
      @comment = new Backbone.Model()

    render: ->
      @$el.html(@template(comment: @comment))
      @attachSubViews()

  postView = new PostView()
  $('#test-container').html(postView.render().el)

  assert.strictEqual 1, subViewRenderCount
  firstSubViewCid = postView.subViews["comment-view-#{postView.comment.cid}"].cid

  postView.render()

  assert.strictEqual 1, subViewRenderCount
  assert.length postView.$el.find('comment-view').length, 1
  assert.strictEqual postView.subViews["comment-view-#{postView.comment.cid}"].cid, firstSubViewCid
)
