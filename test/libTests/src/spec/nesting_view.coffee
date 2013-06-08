describe 'Backbone.Diorama.NestingView', ->
  describe '2 nesting views exist', ->
    viewToRender = null
    before ->
      viewToRender = new Backbone.Views.TestNestingParentView()

      newerView = new Backbone.Views.SecondNestingParentView()

    describe 'rendering the older view', ->
      before ->
        $('#test-container').append(viewToRender.render().el)

      it 'outputs the correct parent template', ->
        expect($('#test-container > div').html()).to.match(/.*TestNestingParent.*/)

      it 'outputs the correct child template', ->
        expect($('#test-container > div').html()).to.match(/.*TestNestingChild.*/)

