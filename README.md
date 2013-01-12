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

    diorama generate-controller <ControllerName> <action1> <action2>

Generates a new BackboneDiorama.Controller, with the specified actions

## Generate Collection View

    diorama generate-collection-view <CollectionName>

Generates a collection view, which will list collection elements, generating 


## Development
BackboneDiorama is written in coffeescript and is packaged as an NPM module. To install the package locally, in the project directory run:

  sudo npm install -g

This will install the diorama command onto your system. On my node setup, this wasn't added to my PATH correct, so check the output for a line like:

    npm info linkStuff backbone-diorama@0.0.1
    /usr/local/share/npm/bin/diorama -> /usr/local/share/npm/lib/node_modules/backbone-diorama/bin/diorama.coffee
