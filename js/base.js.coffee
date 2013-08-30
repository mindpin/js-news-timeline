(Array.slice = (obj)-> @::slice.call(obj)) if !Array.slice

Array::flatten = ->
  @reduce ((a, b)-> a.concat b), []

Array::uniq = ->
  @filter((item, index, items)-> items.indexOf(item) == index)

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

  precedes: (item)->
    @[@sort_by] >= item[@sort_by]

  class_name: ->
    name = @constructor.name
    re   = /[A-Z]/g
    fn   = (c)-> "_#{c}"
    underscored = name[0] + name.slice(1, name.length).replace(/[A-Z]/g, fn)
    underscored.toLowerCase()

class Container
  init_collection: ->
    @[@collection_name] = []

  get_collection: ->
    @[@collection_name]

  collection_for: (item)->
    item.constructor == @collection_item()

  link: (item)->
    item.container = @

  link_before: (input, item)->
    if item.prev
      input.prev = item.prev
      item.prev.next = input

    item.prev = input
    input.next = item

  add: (input)->
    return @ if @has(input)
    return @ if !@collection_for(input)
    i = 0

    @get_collection().some (item, index)=>
      i = index
      if input.precedes(item)
        @link_before(input, item)
        true

    @get_collection().splice(i, 0, input)
    input.add(@) if input.collection_for(@)
    @link(@)

  has: (item)->
    return false if !@collection_for(item)
    @get_collection().indexOf(item) != -1

class EventContainer
  jQuery.extend @::, Container::

  collection_item: -> Event
  collection_name: "events"

  add_event: (input)->
    @add(input)

class PersonContainer
  jQuery.extend @::, Container::

  collection_item:  -> Person
  collection_name: "persons"

  add_person: (person)->
    @add(person)

class ImageRow
  init_images: ->
    @images = []

  add_image: (urls)->
    [arguments...].forEach (url)=>
      @images.push(url)
    @

jQuery.extend window,
  Base: Base
  ImageRow: ImageRow
  EventContainer: EventContainer
  PersonContainer: PersonContainer
