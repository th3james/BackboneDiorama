exports.printGeneratedClassInfo = (modelName, filesGenerated) ->

  console.log "# Generated #{modelName}"
  console.log "add the following to your src/compile_manifest.json"
  console.log "  \"#{filesGenerated.join("\",\n  \"")}\""
  console.log "create an instance with:"
  console.log "  new #{modelName}()"
