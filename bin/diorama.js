#!/usr/bin/env node

var jsonCommand = require("../lib/dioramaCommand");

var args = process.argv.slice(0);
// shift off node and script name
args.shift(); args.shift();

var command = args.shift();

// Default to help command if unrecognised
if (typeof dioramaCommands[command] === 'undefined') {
  console.log('unrecognised command: ' + command);
  command = 'help';
}

dioramaCommands[command].apply(this, args);
