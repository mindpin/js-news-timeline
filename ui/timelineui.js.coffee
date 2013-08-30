class FitImage
  constructor: (@$elm)->
    @src = @$elm.data('src')
    @alt = @$elm.data('alt') || ''

    @loaded = false

  is_in_screen: ->
    width  = @$elm.width()
    height = @$elm.height()
    offset = @$elm.offset()

    $win = jQuery(window)
    window_width  = $win.width()
    window_height = $win.height()
    scroll_left   = $win.scrollLeft()
    scroll_top    = $win.scrollTop()
    
    left   = offset.left - scroll_left
    top    = offset.top - scroll_top
    right  = left + width
    bottom = top + height


    return false if right < 0
    return false if bottom < 0
    return false if left > window_width
    return false if top > window_height

    return true

  load_image: ->
    return if !@is_in_screen()
    return if @loaded

    @$elm.css('overflow', 'hidden')

    if !@src
      console.log('simple-images: fit_image_load() need data-src attr.')
      return

    @$img = jQuery("<img style='display:none;'/>")
            .attr('src', @src)
            .attr('alt', @alt)
            .bind 'load', =>
              @loaded = true
              @resize_image()
              @$img.fadeIn(250)
            .appendTo(@$elm.empty().show())

  resize_image: ->
    return if !@loaded

    box_width  = @$elm.width()
    box_height = @$elm.height()

    img_width  = @$img.width()
    img_height = @$img.height()

    # step 1 如果宽度不等，调齐宽度，计算高度
    w1 = box_width
    if img_width != box_width
      h1 = img_height * box_width / img_width
    else
      h1 = img_height
    
    # step 2 如果此时高度不足，补齐高度
    if h1 < box_height
      rh = box_height
      rw = w1 * box_height / h1
    else
      rh = h1
      rw = w1

    # set position
    left = (box_width  - rw) / 2
    top  = (box_height - rh) / 2

    @$img
      .css('width', rw)
      .css('height', rh)
      .css('margin-left', left)
      .css('margin-top', top)

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

    @build_images()

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
      .append(@$images)
      .append(@$persons)
      .appendTo(@ui.$el)

  build_images: ->
    @$images = jQuery('<div></div>')
      .addClass('images')

    for url in @event.images
      $a = jQuery("<a href='#{url}' target='_blank'></a>")
        .appendTo(@$images)

      $img = jQuery('<div></div>')
        .addClass('img')
        .data('src', url)
        .appendTo($a)

      new FitImage($img).load_image()

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
    X_LEFT = 20
    X_RIGHT = 260

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