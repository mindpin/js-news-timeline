class Base
  @extend = (inf)->
    jQuery.extend @::, inf::

  constructor: (obj)->
    jQuery.extend @, obj

  set: (field, value)->
    @[field] = value
    @

  property: (prop, desc)->
    Object.defineProperty @, prop, desc

  getter: (prop, func)->
    @property prop, get: func

  class_name: ->
    name = @constructor.name
    re   = /[A-Z]/g
    fn   = (c)-> "_#{c}"
    underscored = name[0] + name.slice(1, name.length).replace(/[A-Z]/g, fn)
    underscored.toLowerCase()

class EventContainer
  events: []

  compare: (e1, e2)->
    t1 = e1.time
    t2 = e2.time
    return -1 if t1 >  t2
    return 0  if t1 == t2
    return 1  if t1 <  t2

  add_event: (event)->
    return @ if @events.indexOf(event) != -1
    @events = @events
      .concat([event])
      .sort(@compare)
    event.add_person(@) if @class_name() == "person"
    @

class PersonContainer
  persons: []

  add_person: (person)->
    return @ if @persons.indexOf(person) != -1
    @persons = @persons.concat [person]
    @


jQuery.extend window,
  Base: Base
  EventContainer: EventContainer
  PersonContainer: PersonContainer
