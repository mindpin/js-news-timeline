# 属性: url, desc, people, time, image

class Event extends Base
  jQuery.extend @::, PersonContainer::
  jQuery.extend @::, LinkedItem::

  constructor: (args)->
    super(args)
    @id = Math.random()
    @persons = []

jQuery.extend window,
  Event: Event
