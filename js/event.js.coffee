# 属性: url, desc, people, time, image

class Event extends Base
  jQuery.extend @::, PersonContainer::

  constructor: (args)->
    super(args)
    @init_collection()

  more_recent_than: (evt)->
    @time >= evt.time

jQuery.extend window,
  Event: Event
