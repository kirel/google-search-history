# Setup the dnd listeners.
dropZone = document.getElementById('dropzone')

# read file and return a promise
readFile = (file) ->
  reader = new FileReader
  deferred = $.Deferred()

  reader.onload = (event) ->
    deferred.resolve event.target.result
    return

  reader.onerror = ->
    deferred.reject this
    return

  if /^image/.test(file.type)
    reader.readAsDataURL file
  else
    reader.readAsText file
  deferred.promise()

handleFileSelect = (evt) ->
  evt.stopPropagation()
  evt.preventDefault()
  files = evt.dataTransfer.files
  # FileList object.
  # files is a FileList of File objects. List some properties.
  output = []
  jsons = []
  _.each files, (f) ->
    output.push '<li><strong>', escape(f.name), '</strong> (', f.type or 'n/a', ') - ', f.size, ' bytes, last modified: ', f.lastModifiedDate.toLocaleDateString(), '</li>'
    jsons.push readFile(f)
    return
  document.getElementById('list').innerHTML = '<ul>' + output.join('') + '</ul>'
  events = undefined
  $.when.apply($, jsons).then ->
    jsons = arguments
    events = _.reduce(jsons, ((res, json) ->
      res.push.apply res, JSON.parse(json).event
      res
    ), [])
    document.getElementById('list').innerHTML = JSON.stringify(events)
    return
  return

handleDragOver = (evt) ->
  evt.stopPropagation()
  evt.preventDefault()
  evt.dataTransfer.dropEffect = 'copy'
  # Explicitly show this is a copy.
  return

dropZone.addEventListener 'dragover', handleDragOver, false
dropZone.addEventListener 'drop', handleFileSelect, false
