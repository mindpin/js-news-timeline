class Timeline extends Base
  @extend EventContainer

  constructor: ->
    @events = []

  people: ->
    jQuery.unique @events
      .map((e)=> e.persons)
      .reduce((a, b)=> a.concat b)

jQuery.extend window,
  Timeline: Timeline
