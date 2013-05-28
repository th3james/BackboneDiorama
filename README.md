# BackboneDiorama

BackboneDiorama is everything you need to build client-side web applications.
Optimised for developer happiness, it builds on the components of Backbone.js
and aims to be the easiest and the fastest way to build for the browser.

* `diorama new projectName` builds you a new project with:
  * Logical project structure for Backbone components
  * Coffeescript concatenation and compilation setup
  * Backbone.js+deps and Handlebars templating included and ready for use
* `diorama generate <lots-of-stuff>` - Rails-style code generators which provide convention and structure to your projects, assist you with proven patterns and allow you to rapidly prototype. Run `diorama generate` for [the full list](src/commands/generators#backbonediorama-generators).
* Additional lightweight libraries to plug the gaps in Backbone.js:
  * [*Backbone.Diorama.ManagedRegion*](src/lib/diorama_managed_region.md) - Memory managed view switching.
  * [*Backbone.Diorama.Controller*](src/lib/diorama_controller.md) - Easy switching betweens states in your application.
  * [*Backbone.Diorama.NestingView*](src/lib/diorama_nesting_view.md) - Nest Backbone.Views inside each other.
* New to Backbone.js? The built in conventions and patterns mean there's no easier way to get started.
* Written entirely in and for Coffeescript, for clarity and elegance of code.

We've been using BackboneDiorama to build applications for a little while now,
but this is just the first public release. There's lots more planned (AMD
support, testing defaults, minification, coffeescript source maps and more
generators...) and if you've got any feedback or suggestions, we'd love to hear
from you!

## Installation
Install backbone diorama as an NPM package:

    npm install -g backbone-diorama

## Usage

To view the available commands, run:

    diorama help

Running most commands without arguments will give you the usage.

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

This command watches your src/ folder for changes then concatenates and
compiles the files specified in src/compile_manifest.json to js/application.js.
The files should be specified in the order you require them, in this format:

```json
    [
      "collections/tasks_collection",
      "templates/task_index",
      "views/task_index_view"
    ]
```

When you run a generator, it will print the includes you need to add to this
file.

To run the compile once (without watching for changes), omit the 'watch'
argument:

    diorama compile

## Using BackboneDiorama with Rails and other server frameworks

BackboneDiorama is ready to drop straight into your server side framework.
Simply run `diorama new` inside your javascripts folder (app/assets/javascripts
in Rails), include the the compiled js/application.js in your app, then use
Diorama as normal.

If you're using Rails or another framework with built in coffeescript
compilation, just include the coffeescripts in your src/ directly. Your
templates will still need to be compiled, which you can do by inserting only
the handlebars templates into compile_manifest.json, then using `diorama
compile watch` to compile them to js/application.js

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

## Authors

BackbonDiorama was developed by myself (James Cox,
[@th3james](https://twitter.com/th3james)) and Adam Mulligan
([@amulligan](https://twitter.com/amulligan))

## License

BackboneDiorama is released under the [MIT License](http://opensource.org/licenses/MIT)

## Development

BackboneDiorama is written in coffeescript and is packaged as an NPM
module. To install the package locally, in the project directory run:

    npm install -g

This will install the diorama command onto your system. On my node
setup, this wasn't added to my PATH correctly, so check the output for a
line like:

    npm info linkStuff backbone-diorama@0.0.1
    /usr/local/share/npm/bin/diorama -> /usr/local/share/npm/lib/node_modules/backbone-diorama/bin/diorama.coffee

### Tests

Tests are written using mocha, and in the test/ folder (somewhat
unsurprisingly). Run them with:

    npm test
