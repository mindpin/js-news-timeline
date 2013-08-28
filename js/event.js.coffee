# 属性: url, desc, people, time, image

class Event extends Base
  constructor: (@url)->
    @people = []

  add_person: (person)->
    return @ if @people.indexOf(person) != -1
    @people = @people.concat [person]
    @

jQuery.extend window,
  Event: Event
