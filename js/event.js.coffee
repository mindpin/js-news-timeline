# 属性: url, desc, people, time, image

class Event extends Base
  jQuery.extend @::, PersonContainer::
  jQuery.extend @::, ImageRow::

  sort_by: "time"

  constructor: (args)->
    super(args)
    @init_images()
    @init_collection()

jQuery.extend window,
  Event: Event
