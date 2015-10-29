angular.module('app').directive 'searchBox', ->
  scope:
    search: '='
    searches: '='
  templateUrl: 'search'
  link: (scope, elem, attr) ->
    scope.searches = []
    scope.search = ''
    elem.find('#add').on 'click', ->
      scope.$apply ->
        scope.searches.push term: scope.term

angular.module('app').directive 'searchList', ->
  scope:
    searches: '='
    events: '='
  templateUrl: 'search-list'
  link: (scope, elem, attr) ->

angular.module('app').directive 'termViz', ->
  scope:
    search: '='
    events: '='
  template: '<svg></svg>'
  link: (scope, elem, attr) ->
    chart = nv.models.discreteBarChart()
      .x((d) -> d.x)
      .y((d) -> d.y)
    scope.$watchCollection 'events', (events) ->
      return unless events
      chart.xRange([0, 100])
      re = new RegExp(scope.search.term, 'i')
      filteredEvents = _.filter(events, (event) -> event.query.query_text.search(re) != -1)
      console.log(scope.search)
      console.log(filteredEvents)
      timestamps = (parseInt(event.query.id[0].timestamp_usec) for event in filteredEvents)
      data = [
        values: d3.layout.histogram()(timestamps)
      ]
      chart = nv.models.multiBarChart()
      d3.select(elem.find('svg')[0]).datum(data).call(chart)

