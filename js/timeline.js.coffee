class Timeline extends Base
  jQuery.extend @::, EventContainer::

  constructor: ->
    super()
    @events = []

  events_except: ->
    @select(arguments, except: true)

  events_only: ->
    @select(arguments, only: true)

  common_events: ->
    args = Array.slice(arguments)
    result = args.map((thing)-> thing.get_collection()).reduce (array1, array2)->
      array1.filter (item)->
        array2.indexOf(item) != -1 && item.constructor == Event
    result

  persons: ->
    jQuery.unique @events
      .map((e)=> e.persons)
      .reduce((a, b)=> a.concat b)

  find_person: (name)->
    @persons().filter((person)-> person.name == name)[0]

jQuery.extend window,
  Timeline: Timeline
