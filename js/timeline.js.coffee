class Timeline extends Base
  constructor: ->
    @events = []

  add_event: (event)->
    return @ if @events.indexOf(event) != -1
    @events = @events.concat [event]
    @

  people: ->
    jQuery.unique @events
      .map((e)=> e.persons)
      .reduce((a, b)=> a.concat b)

jQuery.extend window,
  Timeline: Timeline
