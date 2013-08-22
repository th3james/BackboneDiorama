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

test('.generateSubViewPlaceholderTag adds a data-sub-view-key attribute
  with the given key to the view.el', ->
  class TestSubView extends Backbone.View

  nestingView = new Backbone.Diorama.NestingView()
  subView = new TestSubView()
  subViewKey = "test-sub-view-#{subView.cid}"
  html = nestingView.generateSubViewPlaceholderTag(subView, subViewKey).toString()

  viewElement = $.parseHTML(html)[0]
  
  assert.equal($(viewElement).attr('data-sub-view-key'), subViewKey)
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
  class Backbone.Views.CommentView extends Backbone.View
    id: 'comment-view'

    initialize: ->
      @render()

    render: ->
      subViewRenderCount = subViewRenderCount + 1
      @$el.html("render count: #{subViewRenderCount}")

  class PostView extends Backbone.Diorama.NestingView
    template:
      Handlebars.compile("
        <h1>PostView</h1>
        {{addSubViewTo thisView 'CommentView' 'comment-view-{{model.cid}}' model=comment}}
      ")

    initialize: ->
      @comment = new Backbone.Model()

    render: ->
      @$el.html(@template(
        thisView: @
        comment: @comment
      ))
      @attachSubViews()
      return @

  postView = new PostView()
  $('#test-container').html(postView.render().el)

  assert.strictEqual subViewRenderCount, 1
  firstSubViewCid = postView.subViews["comment-view-#{postView.comment.cid}"].cid

  postView.render()

  assert.strictEqual subViewRenderCount, 1
  assert.lengthOf postView.$el.find('#comment-view'), 1
  assert.strictEqual postView.subViews["comment-view-#{postView.comment.cid}"].cid, firstSubViewCid
  
  postView.close()
)

test('.addSubView when given a cacheKeyTemplate that resolves to view that already exists,
  it uses the existing view, rather than creating a new one', ->
  class Backbone.Views.TestSubView extends Backbone.View

  nestingView = new Backbone.Diorama.NestingView()
  nestingView.subViews = {}
  nestingView.subViews['existing-sub-view-1'] = existingSubView = new Backbone.Views.TestSubView()

  generatedTag = nestingView.addSubView('TestSubView', 'existing-sub-view-{{model.cid}}', hash:
    model: {cid: 1}
  )

  # Rendered tag with correct cache key
  assert.match generatedTag.toString(), new RegExp(".*data-sub-view-key=\"existing-sub-view-1\".*")

  assert.strictEqual(
    nestingView.subViews['existing-sub-view-1'].cid,
    existingSubView.cid
  )

  # Should not have created any new keys
  subViewKeys = []
  for k of nestingView.subViews
    subViewKeys.push k
  assert.lengthOf subViewKeys, 1
)

test('.addSubView when not given a cacheKeyTemplate,
  creates a new view', ->
  class Backbone.Views.TestSubView extends Backbone.View

  nestingView = new Backbone.Diorama.NestingView()
  nestingView.subViews = {}
  existingSubView = new Backbone.Views.TestSubView()
  nestingView.subViews[existingSubView.cid] = existingSubView

  nestingView.addSubView('TestSubView', hash:
    model: {cid: 1}
  )
    
  # Should have created new view
  subViews = []
  for k, v of nestingView.subViews
    subViews.push v
  assert.lengthOf subViews, 2
)

test(".closeSubViewsWithoutPlaceholders should close sub views which don't have
  placeholder elements inside the parent nesting view", ->
  class Backbone.Views.TestSubView extends Backbone.View

  nestingView = new Backbone.Diorama.NestingView()
  nestingView.subViews = {}

  placeholderlessView = new Backbone.Views.TestSubView()
  nestingView.subViews['non-existent-placeholder-key'] = placeholderlessView

  subViewCloseSpy = sinon.spy(placeholderlessView, 'close')

  nestingView.closeSubViewsWithoutPlaceholders()

  assert.isUndefined nestingView.subViews['non-existent-placeholder-key']
  assert.ok(
    subViewCloseSpy.calledOnce,
    "expected subViewCloseSpy to be called once, but it was called #{subViewCloseSpy.callCount} times"
  )
  subViewCloseSpy.restore()
)

test(".closeSubViewsWithoutPlaceholders should not close sub views which have
  placeholder elements inside the parent nesting view", ->
  class Backbone.Views.TestSubView extends Backbone.View

  nestingView = new Backbone.Diorama.NestingView()
  nestingView.subViews = {}

  viewWithPlaceholder = new Backbone.Views.TestSubView()
  nestingView.subViews['placeholder-key'] = viewWithPlaceholder

  # Insert placeholder key
  nestingView.$el.append("<div data-sub-view-key='placeholder-key'></div>")

  subViewCloseSpy = sinon.spy(viewWithPlaceholder, 'close')

  nestingView.closeSubViewsWithoutPlaceholders()

  assert.strictEqual nestingView.subViews['placeholder-key'].cid, viewWithPlaceholder.cid
  assert.strictEqual(
    subViewCloseSpy.callCount,
    0,
    "expected subViewCloseSpy not to be called, but it was called #{subViewCloseSpy.callCount} times"
  )
  subViewCloseSpy.restore()
)
