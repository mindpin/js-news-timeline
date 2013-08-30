# 属性: url, desc, people, time, image

class Event extends Base
  jQuery.extend @::, PersonContainer::

  sort_by: "time"

  constructor: (args)->
    super(args)
    @init_collection()

jQuery.extend window,
  Event: Event
