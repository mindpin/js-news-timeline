class Timeline extends Base
  jQuery.extend @::, EventContainer::

  constructor: ->
    super()
    @events = []

  events_except: ->
    persons = Array.prototype.slice.call(arguments)
    events = persons
      .map((person)-> person.events)
      .reduce((a, b)-> a.concat b)
      .filter((event, index, events)-> events.indexOf(event) == index)
    @events.filter (event)=>
      events.indexOf(event) == -1

  events_only: ->
    persons = Array.prototype.slice.call(arguments)
    events = persons
      .map((person)-> person.events)
      .reduce((a, b)-> a.concat b)
      .filter((event, index, events)-> events.indexOf(event) == index)
    @events.filter (event)=>
      events.indexOf(event) != -1

    # @select(arguments,
    #         (event, persons)->
    #           persons
    #             .some((person)=>
    #               event.persons.indexOf(person) == -1))

  persons: ->
    jQuery.unique @events
      .map((e)=> e.persons)
      .reduce((a, b)=> a.concat b)

  find_person: (name)->
    @persons().filter((person)-> person.name == name)[0]

jQuery.extend window,
  Timeline: Timeline
