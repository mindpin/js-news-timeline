class Timeline extends Base
  jQuery.extend @::, EventContainer::

  constructor: ->
    super()
    @events = []

  events_except: (person)->
    @exclude(@events,
             person,
             (event)-> (event.persons.indexOf(person) == -1))

  persons: ->
    jQuery.unique @events
      .map((e)=> e.persons)
      .reduce((a, b)=> a.concat b)

jQuery.extend window,
  Timeline: Timeline
