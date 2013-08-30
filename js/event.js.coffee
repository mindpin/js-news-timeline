# 属性: url, desc, people, time, image

class Event extends Base
  jQuery.extend @::, PersonContainer::

  sort_by: "time"

  constructor: (args)->
    super(args)
    @images = []
    @init_collection()

  add_image: (urls)->
    [arguments...].forEach (url)=>
      @images.push(url)

jQuery.extend window,
  Event: Event
