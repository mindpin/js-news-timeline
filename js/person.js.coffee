# 属性: name, weibo, wiki, events

class Person extends Base
  constructor: (args)->
    super(args)
    @events = []

  add_event: (event)->
    return @ if @events.indexOf(event) != -1
    @events = @events.concat [event]
    event.add_person(@)
    @

jQuery.extend window,
  Person: Person
