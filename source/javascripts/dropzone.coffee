angular.module('app').directive 'dropzone', ($q) ->
  scope:
    events: '='
  link: (scope, elem, attr) ->
    scope.$watchCollection 'events', (events) ->
      if events?.length
        elem.hide()
      else
        elem.show()

    # Setup the dnd listeners.
    dropZone = elem

    # read file and return a promise
    readFile = (file) ->
      reader = new FileReader
      deferred = $q.defer()

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
      deferred.promise

    handleFileSelect = (evt) ->
      evt.stopPropagation()
      evt.preventDefault()
      files = evt.originalEvent.dataTransfer.files
      # FileList object.
      # files is a FileList of File objects. List some properties.
      jsons = (readFile(f) for f in files)

      events = undefined
      $q.all(jsons).then (jsons) ->
        events = _.reduce(jsons, ((res, json) ->
          res.push.apply res, JSON.parse(json).event
          res
        ), [])
        scope.events = events

    handleDragOver = (evt) ->
      evt.stopPropagation()
      evt.preventDefault()
      evt.originalEvent.dataTransfer.dropEffect = 'copy'
      # Explicitly show this is a copy.

    dropZone.on 'dragover', handleDragOver
    dropZone.on 'drop', handleFileSelect
