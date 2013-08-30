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

  hide: ->
    @_is_hide = true

  is_hide: ->
    @_is_hide == true

  animate: (side, left, top)->
    if side

      if side == 'right'
        @$el.addClass('right')
      else
        @$el.removeClass('right')

      @$el.show()
      @$el
        .animate
          left: left
          top: top
          opacity: if @is_hide() then 0 else 1
          =>
            if @is_hide()
            then @$el.hide()
            else @$el.show()

      return @

    @$el.show()
    @$el
      .animate
        opacity: if @is_hide() then 0 else 1
        =>
          if @is_hide()
          then @$el.hide()
          else @$el.show()

    return @

class TimelineUi
  constructor: (@timeline)->
    @$el = jQuery('.page-news-timeline')
    @person_filters = []

  render: ->
    @$filter = jQuery('<div></div>')
      .addClass('filters')
      .append(
        jQuery('<a>全部事件</a>')
          .addClass('filter')
          .addClass('filter-all')
          .attr('href', 'javascript:;')
      )
      .appendTo(@$el)


    for evt in @timeline.events
      evt.ui = new EventUi(@, evt)
      evt.ui.render()

    @rank()
    @bind()

  bind: ->
    that = @

    # 点击事件内的相关人员，按人员过滤
    @$el.delegate '.person a', 'click', ->
      $person = jQuery(this).closest('.person')
      person_name = $person.data('person-name')
      person = that.timeline.find_person(person_name)

      if $person.hasClass('selected')
        that.remove_person_filter(person)
      else
        that.add_person_filter(person)

    # 点击“全部事件”，清除人员过滤器
    @$el.delegate '.filters .filter-all', 'click', ->
      that.clear_person_filters()

    @$el.delegate '.filters .filter-person a.close', 'click', ->
      $filter_person = jQuery(this).closest('.filter-person')
      person_name = $filter_person.data('person-name')
      person = that.timeline.find_person(person_name)

      that.remove_person_filter(person)

  add_person_filter: (person)->
    @person_filters.push person
    @show_filter_events()

    @$el
      .find('.person')
      .filter("[data-person-name=#{person.name}]")
      .addClass('selected')

    @$filter.append(
      jQuery("<div>#{person.name}<a class='close' href='javascript:;'></a></div>")
        .addClass('filter')
        .addClass('filter-person')
        .attr('data-person-name', person.name)
        .attr('href', 'javascript:;')
        .data('find', person.name)
    )

  remove_person_filter: (person)->
    @person_filters.splice @person_filters.indexOf(person), 1
    @show_filter_events()

    @$el
      .find('.person')
      .filter("[data-person-name=#{person.name}]")
      .removeClass('selected')

    @$filter
      .find('.filter-person')
      .filter("[data-person-name=#{person.name}]")
      .remove()

  clear_person_filters: ->
    @person_filters = []
    @show_filter_events()

    @$el.find(".person").removeClass('selected')
    @$filter.find('.filter-person').remove()

  show_filter_events: ->
    pevts = timeline.common_events(@person_filters...)
    for evt in @timeline.events
      if pevts.indexOf(evt) > -1
        evt.ui.show()
      else
        evt.ui.hide()

    @rank()

  rank: ->
    @ltop = 0
    @rtop = 0
    Y_OFFSET = 70
    X_LEFT = 30
    X_RIGHT = 270

    for evt in @timeline.events
      if evt.ui.is_hide()
        evt.ui.animate()
        continue

      if @ltop <= @rtop
        if @rtop - @ltop < Y_OFFSET
          @rtop = @ltop + Y_OFFSET

        evt.ui.animate('left', X_LEFT, @ltop)

        @ltop += evt.ui.size().height
      else
        if @ltop - @rtop < Y_OFFSET
          @ltop = @rtop + Y_OFFSET

        evt.ui.animate('right', X_RIGHT, @rtop)

        @rtop += evt.ui.size().height

    @$el.animate
      height: Math.max(@ltop, @rtop) + 30




window.TimelineUi = TimelineUi