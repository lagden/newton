'use strict'

define [
    'isotope/js/layout-mode',
    'TimelineLite',
    'CSSPlugin'
], (LayoutMode, TimelineLite) ->

  NewtonMode = LayoutMode.create 'newtonMode'

  NewtonMode::_resetLayout = ->
    @x = 0
    @y = 0
    @maxY = 0
    @_getMeasurement 'gutter', 'outerWidth'
    return

  NewtonMode::_getItemLayoutPosition = (item) ->
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

  NewtonMode::_getContainerSize = ->
    height: @maxY

  NewtonMode::_positionItem = (item, x, y, isInstant) ->
    if isInstant
      item.goTo x, y
    else

      item.getPosition()
      curX = item.position.x
      curY = item.position.y

      compareX = parseInt x, 10
      compareY = parseInt y, 10
      didNotMove = compareX == item.position.x and
                   compareY == item.position.y;

      item.setPosition x, y

      if didNotMove and item.isTransitioning
        item.layoutPosition()
        return

      if y == curY
        item.moveTo x, y
      else
        duration = parseFloat item.layout.options.transitionDuration, 10
        animation = new TimelineLite(
          autoRemoveChildren: true
          smoothChildTiming: true
          onComplete: ->
            item.goTo x, y
            return
        )
        if y > curY
          vaiXA = item.layout.size.width - curX
          vaiXB = -item.size.width
        else
          vaiXA = -item.size.width
          vaiXB = item.layout.size.width - x

        animation
          .to(item.element, duration / 2, {
            force3D: true
            css:
              'x': vaiXA
              'opacity': 0
          })
          .set(item.element, {'x': vaiXB, 'left': x, 'top': y})
          .to(item.element, duration / 2, {
            force3D: true
            css:
              'x': 0
              'opacity': 1
          })
          .set(item.element, {'transform': '', '-webkit-transform': ''})

    return

  return NewtonMode
