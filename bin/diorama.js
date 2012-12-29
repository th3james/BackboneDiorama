#!/usr/bin/env node

var jsonCommand = require("../lib/dioramaCommand");

var args = process.argv.slice(0);
// shift off node and script name
args.shift(); args.shift();

// Do something with args...
