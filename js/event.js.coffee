# 属性: url, desc, people, time, image

class Event extends Base
  constructor: (@url)->
    @id = Math.random()
    @persons = []

  add_person: (person)->
    return @ if @persons.indexOf(person) != -1
    @persons = @persons.concat [person]
    @

jQuery.extend window,
  Event: Event
