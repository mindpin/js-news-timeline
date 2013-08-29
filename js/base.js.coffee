class Base
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

class LinkedElement
  sibling: (offset)->
    return if !@container
    return if @container && !@container.events
    collection = @container.events
    collection[collection.indexOf(@) + offset]

  prev: ->
    @sibling(-1)
    
  next: ->
    @sibling(1)

class Container
  exclude: (collection, what, fn)->
    collection.filter (i)->
      if fn then fn(i) else i != what

class Comparable
  compare: (field)->
    (e1, e2)->
      t1 = if field then e1[field] else e1
      t2 = if field then e2[field] else e2
      return -1 if t1 >  t2
      return 0  if t1 == t2
      return 1  if t1 <  t2

class EventContainer
  jQuery.extend @::, Container::
  jQuery.extend @::, Comparable::

  events: []

  link: (event)->
    event.container = @

  add_event: (event)->
    return @ if @events.indexOf(event) != -1
    @events = @events.concat([event]).sort(@compare("time"))
    @link(event)
    event.add_person(@) if @class_name() == "person"
    @

class PersonContainer
  jQuery.extend @::, Container::

  persons: []

  add_person: (person)->
    return @ if @persons.indexOf(person) != -1
    @persons = @persons.concat [person]
    @

jQuery.extend window,
  Base: Base
  Comparable: Comparable
  EventContainer: EventContainer
  PersonContainer: PersonContainer
