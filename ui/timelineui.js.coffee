class EventUi
  constructor: (@ui, @event)->

  render: ->
    console.log @event, @event.url

class TimelineUi
  constructor: (@timeline)->
    console.log @timeline.events
  render: ->
    for evt in @timeline.events
      evt.ui = new EventUi(@, evt)
      evt.ui.render()




window.TimelineUi = TimelineUi