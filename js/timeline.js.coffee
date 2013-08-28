class Timeline extends Base
  jQuery.extend @::, EventContainer::

  constructor: ->
    super()
    @events = []

  persons: ->
    jQuery.unique @events
      .map((e)=> e.persons)
      .reduce((a, b)=> a.concat b)

jQuery.extend window,
  Timeline: Timeline
