# Backbone.Diorama.NestingView

A common pattern for Backbone applications is to nest views inside each
other. For example a collection index view where each model in the
collection gets a sub view. The advantage of this approach is that each
sub view can listen for and respond to events about a particular model,
removing the need for the collection view to be re-rendered.

Backbone.Diorama.NestingView makes it easy to stack views, as seen in
this example PostIndexView

```coffee
class Backbone.Views.PostIndexView extends Backbone.Diorama.NestingView
  template: Handlebars.templates['post_index.hbs']

  initialize: (options) ->
    @postCollection = options.postCollection # A Backbone.Collection
    @render()

  render: =>
    # Close any existing views
    @closeSubViews()
    # Render template, creating subviews with subView helper (see template below)
    @$el.html(@template(thisView: @, posts: @postCollection.models))
    # Render sub views into the elements created by subView helper in the template
    @renderSubViews()

    return @

  onClose: ->
    @closeSubViews()
```

```hbs
### post_index_view template ###
<h1>PostIndex</h1>
{{#each posts}}
  <!-- Create a PostRowView for each post, and add it to the template with subView -->
  {{addSubViewTo ../thisView "PostRowView" model=this}}
{{/each}}
```

