#BackboneDiorama

A Backbone.js based client-side Coffeescipt web application framework
designed for rapid development, using opinionated backbone pattern
generators.

## Goals

BackboneDiorama aims to assist you in rapid building of client-side web
applications. To do this, it borrows much of the philosophy of Ruby On
Rails, particularly, convention over configuration. BackboneDiorama
creates a default Backbone.js application structure, and provides a
series of patterns useful for typical web development, which are
realised through generators.  BackboneDiorama and its generators are
designed exclusively for Coffeescript in the interests of the clarity
and elegance of generated code.

## Installation
Install backbone diorama as an NPM package:

    sudo npm install -g backbone-diorama

## Usage

To view the available commands, run:

    diorama help

#### Create a new project

    diorama new <ProjectName>

This will create a new diorama project inside a directory of the same
name. It creates an `index.html` file containing starting instructions.

#### Use the generators

Use generators to scaffold your code, for example:

    diorama generate collection Tasks
    diorama generate view TaskIndex

For a [complete list](src/commands/generators) of generators
available, run:

    diorama generate

#### Compiling the app

    diorama compile watch

This command watches your src/ folder for changes and compiles the
files specified in src/compile_manifest.json.
The files should be specified in the order you require them, in this
format:

```json
    [
      "collections/tasks_collection",
      "templates/task_index",
      "views/task_index_view"
    ]
```

To run the compile once without watching for changes, omit the 'watch'
argument:

    diorama compile

## Backbone.Diorama Libraries

BackboneDiorama comes with a few extra classes to compliment the
backbone stack for building complete web applications:

#### Backbone.Diorama.ManagedRegion

Creates a DOM element designed for swapping views in and out of, with
helper methods to manage unbinding events.

[Read More](src/lib/diorama_managed_region.md)

#### Backbone.Diorama.Controller

Diorama controllers are designed to coordinate views and data, and
provide entry points to certain 'states' of your application.
Routers in BackboneDiorama projects only handle URL reading and
setting, but defer to controllers for the actual behavior.

[Read More](src/lib/diorama_controller.md)

#### Backbone.Diorama.NestingView

A common pattern for Backbone applications is to nest views inside each
other. For example a collection index view where each model in the
collection gets a sub view. The advantage of this approach is that each
sub view can listen for and respond to events about a particular model,
removing the need for the collection view to be re-rendered.

Backbone.Diorama.NestingView makes it easy to stack views like this.

[Read More](src/lib/diorama_nesting_view.md)

## Development

BackboneDiorama is written in coffeescript and is packaged as an NPM
module. To install the package locally, in the project directory run:

    sudo npm install -g

This will install the diorama command onto your system. On my node
setup, this wasn't added to my PATH correctly, so check the output for a
line like:

    npm info linkStuff backbone-diorama@0.0.1
    /usr/local/share/npm/bin/diorama -> /usr/local/share/npm/lib/node_modules/backbone-diorama/bin/diorama.coffee

### Tests

Tests are written using mocha, and in the test/ folder (somewhat
unsurprisingly). Run them with:

    npm test
