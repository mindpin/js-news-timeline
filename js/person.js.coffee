# 属性: name, weibo, wiki, events

class Person extends Base
  @extend EventContainer

  constructor: (args)->
    super(args)
    @events = []

jQuery.extend window,
  Person: Person
