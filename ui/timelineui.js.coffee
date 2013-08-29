class PersonUi

class EventUi
  constructor: (@ui, @event)->

  render: ->
    @$time = jQuery('<div></div>')
      .addClass('time')
      .html(@time_format())

    @$url = jQuery('<a></a>')
      .addClass('url')
      .attr('href', @event.url)
      .attr('target', '_blank')
      .html(@event.url)

    @$desc = jQuery('<div></div>')
      .addClass('desc')
      .html(@event.desc)

    @$persons = jQuery('<div></div>')
      .addClass('persons')

    for person in @event.persons
      jQuery('<div></div>')
        .addClass('person')
        .data('person-name', person.name)
        .appendTo(@$persons)
        .append jQuery('<a></a>').attr('href', 'javascript:;').html(person.name)

    @$el = jQuery('<div></div>')
      .addClass('event')
      .append(@$time)
      .append(@$desc)
      .append(@$url)
      .append(@$persons)
      .appendTo(@ui.$el)

  size: ->
    return {
      width: @$el.width()
      height: @$el.height() + 60
    }

  time_format: ->
    t = @event.time
    a = "#{t.getFullYear()}-#{t.getMonth() + 1}-#{t.getDate()}"
    b = "#{t.getHours()}:#{t.getMinutes()}"

    "#{a} #{if b != '0:0' then b else ''}"

  show: ->
    @_is_hide = false
    @$el.fadeIn()

  hide: ->
    @_is_hide = true
    @$el.fadeOut()

  is_hide: ->
    @_is_hide == true

class TimelineUi
  constructor: (@timeline)->
    @$el = jQuery('.page-news-timeline')

  render: ->
    # @$filter = jQuery('<div></div>')
    #   .addClass('filter')


    for evt in @timeline.events
      evt.ui = new EventUi(@, evt)
      evt.ui.render()

    @rank()
    @bind()

  bind: ->
    that = @
    @$el.delegate '.person a', 'click', ->
      person_name = jQuery(this).closest('.person').data('person-name')
      person = that.timeline.find_person(person_name)
      console.log person
      pevts = person.events

      for evt in that.timeline.events
        if pevts.indexOf(evt) > -1
          evt.ui.show()
        else
          evt.ui.hide()

      that.rank()

  rank: ->
    window.ltop = 0
    window.rtop = 0

    for evt in @timeline.events
      continue if evt.ui.is_hide()

      # console.log evt

      if window.ltop <= window.rtop
        if window.rtop - window.ltop < 70
          window.rtop = window.ltop + 70

        evt.ui.$el
          .removeClass('right')
          .animate
            left: 30
            top: window.ltop
        window.ltop += evt.ui.size().height
      else
        if window.ltop - window.rtop < 70
          window.ltop = window.rtop + 70

        evt.ui.$el
          .addClass('right')
          .animate
            left: 270
            top: window.rtop
        window.rtop += evt.ui.size().height

    @$el.animate
      height: Math.max(window.ltop, window.rtop) + 30




window.TimelineUi = TimelineUi