'use strict'

define [
    'outlayer/outlayer'
    'isotope/js/layout-mode',
    'TweenMax'
], (Outlayer, LayoutMode, TM) ->

  extend = (a, b) ->
    for prop of b
      a[prop] = b[prop]
    a

  NewtonOutlayer = Outlayer.create 'newtonOutlayer'

  NewtonOutlayer::_resetLayout = ->
    @x = 0
    @y = 0
    @maxY = 0
    @_getMeasurement 'gutter', 'outerWidth'
    return

  NewtonOutlayer::_getItemLayoutPosition = (item) ->
    console.trace()
    item.getSize()
    itemWidth = item.size.outerWidth + @gutter
    # if this element cannot fit in the current row
    containerWidth = @isotope.size.innerWidth + @gutter
    if @x != 0 and itemWidth + @x > containerWidth
      @x = 0
      @y = @maxY
    position =
      x: @x
      y: @y
    @maxY = Math.max(@maxY, @y + item.size.outerHeight)
    @x += itemWidth
    position

  NewtonOutlayer::_getContainerSize = ->
    height: @maxY

  NewtonOutlayer::_positionItem = (item, x, y, isInstant) ->
    if isInstant
      item.goTo x, y
    else
      current =
        x: item.element.style.left
        y: item.element.style.top

      if(current.y != y)
        item.goTo x, y
      else
        item.moveTo x, y
    return

  NewtonMode = LayoutMode.create 'newtonMode'
  extend NewtonMode::, NewtonOutlayer::

  return NewtonMode
