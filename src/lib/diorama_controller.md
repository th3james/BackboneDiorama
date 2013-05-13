# Backbone.Diorama.Controller

Diorama controllers are designed to coordinate views and data, and
provide entry points to certain 'states' of your application.
Routers in BackboneDiorama projects only handle URL reading and
setting, but defer to controllers for the actual behavior.

This example shows shows a typical blog post index and show page:

```coffee
class Backbone.Controllers.PostsController extends Backbone.Diorama.Controller
  constructor: ->
    # Create a ManagedRegion to render views into
    @mainRegion = new Backbone.Diorama.ManagedRegion()
    $('body').append(@mainRegion.$el)

    # Start state
    @index()

  index: =>
    postCollection = new Backbone.Collection.PostCollection()

    # Create a post index view, and show it in mainRegion
    indexView = new Backbone.Views.PostIndexView(postCollection: postCollection)
    @mainRegion.showView(indexView)

    # Listen to the Backbone object for a 'post:show' event,
    # then transition to the show state when it occurs
    @changeStateOn(
      {event: 'post:show', publisher: Backbone, newState: @show}
    )

  show: (post) =>
    # Create a show view for the given post,
    # and show it in the @mainRegion
    showView = new Backbone.Views.PostShowView(post: post)
    @mainRegion.showView(showView)

    # Listen to the showView for the 'back' event,
    # and return to the index when it occurs
    @changeStateOn(
      {event: 'back', publisher: showView, newState: @index}
    )
```

