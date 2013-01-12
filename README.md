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
    
    diorama new ProjectName

This will create a new diorama project inside a directory of the same name

## Development
BackboneDiorama is written in coffeescript and is packaged as an NPM module. To install the package locally, in the project directory run:

  sudo npm install -g

This will install the diorama command onto your system. On my node setup, this wasn't added to my PATH correct, so check the output for a line like:

    npm info linkStuff backbone-diorama@0.0.1
    /usr/local/share/npm/bin/diorama -> /usr/local/share/npm/lib/node_modules/backbone-diorama/bin/diorama.coffee

To see exactly where the command has been installed
