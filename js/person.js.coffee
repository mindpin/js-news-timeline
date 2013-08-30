# 属性: name, weibo, wiki, events

class Person extends Base
  jQuery.extend @::, EventContainer::
  jQuery.extend @::, ImageRow::

  constructor: (args)->
    super(args)
    @init_images()
    @init_collection()

jQuery.extend window,
  Person: Person
