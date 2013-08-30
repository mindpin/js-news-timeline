(Array.slice = (obj)-> @::slice.call(obj)) if !Array.slice

Array::flatten = ->
  @reduce ((a, b)-> a.concat b), []

Array::uniq = ->
  @filter((item, index, items)-> items.indexOf(item) == index)

Array::intersection = ->
  arrays = Array.slice(arguments)
  arrays.reduce (array1, array2)->
    #array1.filter (item)

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

class Container
  select: (things, options)->
    {except: except, only: only} = options
    collection = Array.slice(things)
      .map((thing)-> thing.get_collection()).flatten().uniq()
    @get_collection().filter (item)=>
      return collection.indexOf(item) == -1 if except == true
      collection.indexOf(item) != -1 if only == true

  init_collection: ->
    @[@collection_name] = []

  get_collection: ->
    @[@collection_name]

  link: (item)->
    item.container = @

  add: (item)->
    return @ if @has(item)
    @get_collection().push(item)
    item.add(@) if item.collection_for() == @constructor
    @link(item)

  has: (item)->
    @get_collection().indexOf(item) != -1

class EventContainer
  jQuery.extend @::, Container::

  collection_for:  -> Event
  collection_name: "events"
  sort_by: "time"

  add_event: (input_event)->
    return @ if @has(input_event)
    return @ if input_event.constructor != Event

    i = 0
    for evt in @events
      if input_event.more_recent_than(evt)
        if evt.prev
          input_event.prev = evt.prev
          evt.prev.next = input_event

        evt.prev = input_event
        input_event.next = evt

        break
      i++

    arr0 = @events[0...i]
    arr1 = [input_event]
    arr2 = @events[i...@events.length]

    @events = arr0.concat(arr1).concat(arr2)

    input_event.add(@) if @.constructor == Person


class PersonContainer
  jQuery.extend @::, Container::

  collection_for:  -> Person
  collection_name: "persons"

  add_person: (person)->
    @add(person)

jQuery.extend window,
  Base: Base
  EventContainer: EventContainer
  PersonContainer: PersonContainer
