BackboneDiorama
===============

A client-side web application framework designed for rapid development, using opinionated backbone pattern generators

# Goals
Backbone Diorama aims to assist you in rapid building of client-side web applications. To do this, it borrows much of the 
philosophy of Ruby On Rails, particularly, convention over configuration. Backbone Diorama creates a default Backbone.js
application structure, and a series of patterns useful for typical web development, which are realised through geneators.

# Usage
To view the availble commands, run:

  diorama help

## Create a new project
    
    diorama new <ProjectName>

This will create a new diorama project inside a directory of the same name

## CRUD scaffold
    
    diorama scaffold <ModelName> <fieldName:type> <fieldName2:type> ...

Will create a CRUD scaffold for a given model description. A good starting point to see how projects work together

## Generate Controller

    diorama generate-controller <ControllerName> <Action1> <Action2> ...

Generates a new BackboneDiorama.Controller, with the specified actions

## Generate Collection View

    diorama generate-collection-view <CollectionName>

Generates a collection view, which will list collection elements, generating 

# Extra helper objects
BackboneDiorama comes with a few helpers to complete the backbone stack for building complete web applications:

## DioramaController
Diorama controllers are designed to coordinate views in your application, and provide entry points to certain 'states' of your application. Routers in BackboneDiorama projects only handle URLs reading and setting, but defer to controllers for the actual behavior.
This example shows shows a typical blog post index and show page:

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
        @mainRegion.show(indexView)

        # Listen to the Backbone object for a 'post:show' event,
        # then transition to the show state when it occurs
        @changeStateOn(
          {event: 'post:show', publisher: Backbone, newState: @show}
        )

      show: (post) =>
        # Create a show view for the given post,
        # and show it in the @mainRegion
        showView = new Backbone.Views.PostShowView(post: post)
        @mainRegion.show(showView)

        # Listen to the showView for the 'back' event,
        # and return to the index when it occurs
        @changeStateOn(
          {event: 'back', publisher: showView, newState: @index}
        )
    

## Development
BackboneDiorama is written in coffeescript and is packaged as an NPM module. To install the package locally, in the project directory run:

  sudo npm install -g

This will install the diorama command onto your system. On my node setup, this wasn't added to my PATH correct, so check the output for a line like:

    npm info linkStuff backbone-diorama@0.0.1
    /usr/local/share/npm/bin/diorama -> /usr/local/share/npm/lib/node_modules/backbone-diorama/bin/diorama.coffee
