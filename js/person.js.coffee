# 属性: name, weibo, wiki, events

class Person extends Base
  jQuery.extend @::, EventContainer::

  constructor: (args)->
    super(args)
    @init_collection()

jQuery.extend window,
  Person: Person
