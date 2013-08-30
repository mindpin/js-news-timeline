class Timeline extends Base
  jQuery.extend @::, EventContainer::

  constructor: ->
    super()
    @events = []

  # 取得不包含这几个人的 events
  events_except: ->
    args = arguments
    @events.filter (evt)=>
      flag = true
      for person in [args...]
        if evt.has(person)
          flag = false
          break
      flag

  # 取得至少包含这几个人之一的 events
  events_only: ->
    args = arguments
    @events.filter (evt)=>
      flag = false
      for person in [args...]
        if evt.has(person)
          flag = true
          break
      flag

  # 取得 events，其中每个event都要包含这几个人
  common_events: ->
    args = arguments
    @events.filter (evt)=>
      flag = true
      for person in [args...]
        if !evt.has(person)
          flag = false
          break
      flag

  persons: ->
    jQuery.unique @events
      .map((e)=> e.persons)
      .reduce((a, b)=> a.concat b)

  find_person: (name)->
    @persons().filter((person)-> person.name == name)[0]

jQuery.extend window,
  Timeline: Timeline
