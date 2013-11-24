assert = chai.assert

suite('Backbone.View close hook')

test('an event bound to the close event is called when a view is close', ->
  class ClosingView extends Backbone.View
    initialize: ->
      @listenTo(@, 'close', @closeListener)

    closeListener: ->
      console.log "Closing the view"

  closeListenerSpy = sinon.spy(ClosingView::, 'closeListener')

  closingView = new ClosingView()

  closingView.close()

  try
    assert.strictEqual closeListenerSpy.callCount, 1,
      "Expected the closeListener to be called on close"
  finally
    closeListenerSpy.restore()
)

test("if a view defines an onClose method which isn't bound to 'close'
 a deprecation error is throw", ->
  class ClosingView extends Backbone.View
    initialize: ->
      @on('close', ->)
    onClose: ->

  onCloseSpy = sinon.spy(ClosingView::, 'onClose')

  closingView = new ClosingView()

  try
    assert.throws(
      (-> closingView.close()),
      "onClose is no longer called automatically, please listenTo the view's 'close' event"
    )
    assert.strictEqual onCloseSpy.callCount, 0,
      "Expected the onClose not to be called"
  finally
    onCloseSpy.restore()
)

test("if a view defines an onClose method which is bound to 'close'
 no deprecation notice is logged", ->
  class ClosingView extends Backbone.View
    initialize: ->
      @listenTo(@, 'close', @onClose)

    onClose: ->

  onCloseSpy = sinon.spy(ClosingView::, 'onClose')

  closingView = new ClosingView()
  closingView.close()

  try
    assert.strictEqual onCloseSpy.callCount, 1,
      "Expected the onClose to be called once"
  finally
    onCloseSpy.restore()
)
