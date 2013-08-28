class Timeline extends Base
  constructor: ->
    @events = []

  add_event: (event)->
    return @ if @events.indexOf(event) != -1
    @events = @events.concat [event]
    @

  people: ->
    @events
      .map((e)=> e.people)
      .reduce((a, b)=> a.concat b)

jQuery.extend window,
  Timeline: Timeline
