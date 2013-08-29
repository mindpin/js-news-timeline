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
        .attr('data-person-name', person.name)
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
    @$filter = jQuery('<div></div>')
      .addClass('filters')
      .append(
        jQuery('<a>全部事件</a>')
          .addClass('filter')
          .attr('href', 'javascript:;')
          .data('find', 'all')
      )
      .appendTo(@$el)


    for evt in @timeline.events
      evt.ui = new EventUi(@, evt)
      evt.ui.render()

    @rank()
    @bind()

  bind: ->
    that = @

    @$el.delegate '.person a', 'click', ->
      $person = jQuery(this).closest('.person')
      person_name = $person.data('person-name')
      person = that.timeline.find_person(person_name)

      if $person.hasClass('selected')
        that.show_all()
      else
        that.only_show(person)

    @$el.delegate '.filters .filter', 'click', ->
      find = jQuery(this).data('find')
      if find == 'all'
        that.show_all()

    @$el.delegate '.filters .filter-person a.close', 'click', ->
      that.show_all()


  only_show: (person)->
    pevts = person.events
    for evt in @timeline.events
      if pevts.indexOf(evt) > -1
        evt.ui.show()
      else
        evt.ui.hide()

    @$el.find(".person").removeClass('selected')
    @$el.find(".person[data-person-name=#{person.name}]").addClass('selected')
    @rank()

    @$filter.find('.filter-person').remove()
    @$filter.append(
      jQuery("<div>#{person.name}<a class='close' href='javascript:;'></a></div>")
        .addClass('filter')
        .addClass('filter-person')
        .attr('href', 'javascript:;')
        .data('find', person.name)
    )

  show_all: ->
    for evt in @timeline.events
      evt.ui.show()
    @$el.find(".person").removeClass('selected')
    @rank()

    @$filter.find('.filter-person').remove()

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