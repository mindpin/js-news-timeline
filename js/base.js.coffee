class Base
  set: (field, value)->
    @[field] = value
    @

  property: (prop, desc)->
    Object.defineProperty @, prop, desc

  getter: (prop, func)->
    @property prop, get: func

  class_name: ->
    name = @constructor.name
    re   = /[A-Z]/g
    fn   = (c)-> "_#{c}"
    underscored = name[0] + name.slice(1, name.length).replace(/[A-Z]/g, fn)
    underscored.toLowerCase()

jQuery.extend window,
  Base: Base
