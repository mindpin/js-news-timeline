class Timeline extends Base
  constructor: ->
    @events = []

  add_event: (event)->
    @events = @events.concat [event]

  people: ->
    @events
      .map((e)=> e.people)
      .reduce((a, b)=> a.concat b)
