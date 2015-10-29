#= require_self
#= require_tree .
angular.module('app', [])

angular.module('app').directive 'eventList', ->
  scope:
    events: '='
  link: (scope, elem, attr) ->
    scope.$watchCollection 'events', (events) ->
      elem.html JSON.stringify(events)
