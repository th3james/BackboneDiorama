# Backbone.Diorama.ManagedRegion

Creates a DOM element designed for swapping views in and out of, with helper methods to manage unbinding events.

## constructor(tagName='div')

Constructs a new managed region with a DOM element of the given tag name. Insert the new DOM element into the page using the $el attribute:

```coffee
@mainRegion = new Backbone.Diorama.ManagedRegion('span')
$('body').append(managedRegion.$el)
```

## showView(backboneView)

Renders the given Backbone.View into the managedRegion's DOM element. If
there has already been a Backbone.View rendered for the region, the
existing view will be closed, calling onClose() on it, and then
replacing it with the new view. This allows you to swap views into the
region without having to manually clean up after old views.

```coffee
managedRegion.showView(view1) # Render view 1 into managedRegion.$el
managedRegion.showView(view2) # Call view1.close() and view1.onClose(), render view2 into managedRegion.$el
```
