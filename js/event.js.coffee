# 属性: url, desc, people, time, image

class Event extends Base
  jQuery.extend @::, PersonContainer::

  constructor: (args)->
    super(args)
    @id = Math.random()
    @persons = []

  prev: ->
    return if !@container
    return if @container && !@container.events
    collection = @container.events
    collection[collection.indexOf(@) - 1]
    
  next: ->
    return if !@container
    return if @container && !@container.events
    collection = @container.events
    collection[collection.indexOf(@) + 1]

jQuery.extend window,
  Event: Event
