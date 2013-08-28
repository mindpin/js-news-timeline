# 属性: url, desc, people, time, image

class Event extends Base
  @extend PersonContainer

  constructor: (args)->
    super(args)
    @id = Math.random()
    @persons = []

jQuery.extend window,
  Event: Event
