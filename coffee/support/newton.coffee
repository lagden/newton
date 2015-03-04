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
    @itemWidth = 0
    return

  NewtonMode::_getItemLayoutPosition = (item) ->
    item.getSize()

    itemWidth = item.size.outerWidth + @gutter
    containerWidth = @isotope.size.innerWidth + @gutter

    @itemWidth = Math.max @itemWidth, itemWidth

    if @x != 0 and itemWidth + @x > containerWidth
      @x = 0
      @y = @maxY

    position =
      x: @x
      y: @y

    @maxY = Math.max @maxY, @y + item.size.outerHeight
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
                   compareY == item.position.y

      if item.id == 26
        console.log curX, x, @itemWidth

      item.setPosition x, y

      if didNotMove and item.isTransitioning
        item.layoutPosition()
        return

      if y == curY
        item.moveTo x, y
      else
        duration = parseFloat item.layout.options.transitionDuration, 10
        animation = new TimelineLite
          autoRemoveChildren: true
          smoothChildTiming: true
          onComplete: ->
            item.goTo x, y
            item.emitEvent 'transitionEnd', [ item ]
            return

        if y > curY
          vaiXA = @itemWidth + item.size.width + 200
          vaiXB = -@itemWidth - item.size.width - 200
        else
          vaiXA = -@itemWidth - item.size.width - 200
          vaiXB =  @itemWidth + item.size.width + 200

        animation
          .to(item.element, duration, {
            force3D: true
            css:
              'x': vaiXA
              'clearProps': 'transform,matrix'
          })
          .set(item.element, {'x': vaiXB, 'left': x, 'top': y})
          .to(item.element, duration, {
            force3D: true
            css:
              'x': 0
              'clearProps': 'transform,matrix'
          })

    return

  return NewtonMode
