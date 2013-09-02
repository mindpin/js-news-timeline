class JSONSerializable
  toJSON: ->
    @["#class"] = @constructor.name
    @

  defined_class: (v)->
    typeof v      == "object" &&
    v             != null     &&
    v.constructor != Object   &&
    v.constructor != Array

  serialize: ->
    cache = {}; counter = 0; self = @
    json = JSON.stringify @, (k, v)->
      if self.defined_class(v)
        return {ref: v.ref_id} if v.ref_id
        counter++
        v.ref_id = "#{v.constructor.name}#{counter}"
        cache[v.ref_id] = v
      v
    console.log("cache2---->", cache)
    json

  @deserialize: (json)->
    cache = {}
    obj = JSON.parse json, (k, v)->
      if @ref_id
        cache[@ref_id] = @
        delete @ref_id
      if v.ref
        return cache[v.ref]
      if @["#class"]
        @.__proto__ = window[@["#class"]]::
        delete @["#class"]
      v
    console.log("cache2---->", cache)
    obj

class Base
  jQuery.extend @, JSONSerializable
  jQuery.extend @::, JSONSerializable::

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

console.log Base
