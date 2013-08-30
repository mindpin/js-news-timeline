# 属性: name, weibo, wiki, events

class Person extends Base
  jQuery.extend @::, EventContainer::

  constructor: (args)->
    super(args)
    @images = []
    @init_collection()

  add_image: (urls)->
    [arguments...].forEach (url)=>
      @images.push(url)

jQuery.extend window,
  Person: Person
