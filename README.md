BackboneDiorama
===============

A Backbone.js based client-side Coffeescipt web application framework designed for rapid development, using opinionated backbone pattern generators.

# Goals
Backbone Diorama aims to assist you in rapid building of client-side web applications. To do this, it borrows much of the 
philosophy of Ruby On Rails, particularly, convention over configuration. Backbone Diorama creates a default Backbone.js
application structure, and provides a series of patterns useful for typical web development, which are realised through generators.
BackboneDiorama and its generators are designed exclusively for Coffeescript in the interests of the clarity and elegance of generated code.

# Installation
Install backbone diorama as an NPM package:

	sudo npm install -g backbone-diorama

# Usage
To view the availble commands, run:

	diorama help

#### Create a new project
    
    diorama new <ProjectName>

This will create a new diorama project inside a directory of the same name. It creates an index.html file containing starting instructions.

#### generateController

    diorama generateController <ControllerName> <Action1> <Action2> ...

Generates a new Backbone.Diorama.Controller, with the specified actions, and a corresponding view for each action. Generated files are printed in a format suitable for inserting into the src/compile_manifest.json

#### generateView

    diorama generateView <ViewName>

Generates a new Backbone.View and JST template file for the given name. Generated files are printed in a format suitable for inserting into the src/compile_manifest.json

#### Compiling the app

    diorama compile <watch>

Compiles compiles the files specied in src/compile_manifest.json. The files should be specified in the order you require them, in this format:

	[
		"folderRelativeToSrc/filewithoutext",
		"another/coffescriptFile",
	]


# Backbone.Diorama Libraries
BackboneDiorama comes with a few extra classes to complete the backbone stack for building complete web applications:

### Backbone.Diorama.ManagedRegion
Creates a DOM element designed for swapping views in and out of
#### constructor(tagName='div')
Constructs a new managed region with a DOM element of the given tag name. Insert the new DOM element into the page using the $el attribute:

```coffee
@mainRegion = new Backbone.Diorama.ManagedRegion('span')
$('body').append(managedRegion.$el)
```

#### showView(backboneView)
Renders the given Backbone.View into the managedRegion's DOM element. If there has already been a Backbone.View rendered for the region, the existing view will be closed, calling onClose() on it, and then replacing it with the new view. This allows you to swap views into the region without having to manually clean up after old views.

```coffee
managedRegion.showView(view1) # Render view 1 into managedRegion.$el
managedRegion.showView(view2) # Call view1.close() and view1.onClose(), render view2 into managedRegion.$el
```

### Backbone.Diorama.Controller
Diorama controllers are designed to coordinate views in your application, and provide entry points to certain 'states' of your application. Routers in BackboneDiorama projects only handle URLs reading and setting, but defer to controllers for the actual behavior.
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

## Planned features
#### CRUD scaffold
    
    diorama scaffold <ModelName> <fieldName:type> <fieldName2:type> ...

Will create a CRUD scaffold for a given model description. A good starting point to see how projects work together

#### Generate Collection View

    diorama generate-collection-view <CollectionName>

Generates a collection view, which will list collection elements, generating 


    

## Development
BackboneDiorama is written in coffeescript and is packaged as an NPM module. To install the package locally, in the project directory run:

  sudo npm install -g

This will install the diorama command onto your system. On my node setup, this wasn't added to my PATH correct, so check the output for a line like:

    npm info linkStuff backbone-diorama@0.0.1
    /usr/local/share/npm/bin/diorama -> /usr/local/share/npm/lib/node_modules/backbone-diorama/bin/diorama.coffee
