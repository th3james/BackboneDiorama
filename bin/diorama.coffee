#!/usr/bin/env coffee

dioramaCommands = require("../lib/dioramaCommand")

args = process.argv.slice(0)
# shift off node and script name
args.shift(); args.shift()

command = args.shift()

# Default to help command if unrecognised
unless dioramaCommands[command]?
  console.log('unrecognised command: ' + command)
  command = 'help'

dioramaCommands[command].apply(this, args)
