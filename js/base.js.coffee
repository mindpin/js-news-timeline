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

class LinkedItem
  sibling: (offset)->
    return if !@container
    return if @container && !@container.get_collection()
    collection = @container.get_collection()
    collection[collection.indexOf(@) + offset]

  prev: ->
    @sibling(-1)
    
  next: ->
    @sibling(1)

class Container
  select: (things, fn)->
    collection = Array.prototype.slice.call(things)
    collection
      .map((thing)=>
        @get_collection().filter (item)=>
          if fn then fn(item, collection) else i == thing)
      .reduce((a, b)-> a.concat b)
      .filter((item, index, array)=>
        array.indexOf(item) == index)

  init_collection: ->
    @[@collection_name] = []

  get_collection: ->
    @[@collection_name]

  link: (item)->
    item.container = @

  sort: ->
    @[@collection_name] = @get_collection().sort(@compare(@sort_by)) if @sort_by
    @

  add: (item)->
    return @ if @get_collection().indexOf(item) != -1
    @[@collection_name] = @get_collection().concat([item])
    item.add(@) if item.collection_for() == @constructor
    @sort().link(item)

class Sortable
  compare: (field)->
    (e1, e2)->
      t1 = if field then e1[field] else e1
      t2 = if field then e2[field] else e2
      return -1 if t1 >  t2
      return 0  if t1 == t2
      return 1  if t1 <  t2

class EventContainer
  jQuery.extend @::, Sortable::
  jQuery.extend @::, Container::

  collection_for:  -> Event
  collection_name: "events"
  sort_by: "time"

  add_event: (event)->
    @add(event)

class PersonContainer
  jQuery.extend @::, Container::

  collection_for:  -> Person
  collection_name: "persons"

  add_person: (person)->
    @add(person)

jQuery.extend window,
  Base: Base
  Sortable: Sortable
  EventContainer: EventContainer
  PersonContainer: PersonContainer
  LinkedItem: LinkedItem
