describe 'Backbone.Diorama.NestingView', ->
  it 'create an new instance without error', ->
    expect(->
      new Backbone.Diorama.NestingView()
    ).to.not.throwException()

