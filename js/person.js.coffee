# 属性: name, weibo, wiki, events

class Person extends Base
  constructor: (@name)->
    @events = []

  add_event: (event)->
    @events = @events.concat [event]
    event.add_person(@)

jQuery.extend window,
  Person: Person
