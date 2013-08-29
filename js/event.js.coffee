# 属性: url, desc, people, time, image

class Event extends Base
  jQuery.extend @::, PersonContainer::
  jQuery.extend @::, LinkedElement::

  constructor: (args)->
    super(args)
    @id = Math.random()
    @persons = []

jQuery.extend window,
  Event: Event
