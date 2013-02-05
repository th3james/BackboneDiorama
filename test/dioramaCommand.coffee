dioramaCommands = require("../src/dioramaCommand")
assert = require("assert")
fs = require('fs-extra')

describe('create a new project', ->
  dioramaCommands.new('testProject')
  it('should create all the correct directories', ->
    expectedDirs = ['js', 'src']
    foundDirs = fs.readdirSync('testProject/').filter((n) ->
      if(expectedDirs.indexOf(n) == -1)
        return false
      return true
    )
    assert.equal(foundDirs.length, expectedDirs.length)
  )
  it("should have copied libs across", ->
    expectedFiles = ['backbone-min.js', 'jquery-1.8.3.min.js', 'underscore-min.js', 'diorama.js', 'json2.js']
    foundDirs = fs.readdirSync('testProject/js/lib').filter((n) ->
      if(expectedFiles.indexOf(n) == -1)
        return false
      return true
    )
    assert.equal(foundDirs.length, expectedFiles.length)
  )
  # Clean-up
  fs.rmdirSync('testProject')
)