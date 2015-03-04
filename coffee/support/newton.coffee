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
    @diff = 0
    return

  NewtonMode::_getItemLayoutPosition = (item) ->
    item.getSize()

    itemWidth = item.size.outerWidth + @gutter
    containerWidth = @isotope.size.innerWidth + @gutter

    @diff = window.innerWidth - containerWidth
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

      item.setPosition x, y

      if didNotMove and item.isTransitioning
        item.layoutPosition()
        return

      if y == curY
        item.moveTo x, y
      else
        console.log @diff
        duration = parseFloat item.layout.options.transitionDuration, 10
        latency = duration / 2
        animation = new TimelineLite
          autoRemoveChildren: true
          smoothChildTiming: true
          onComplete: ->
            item.goTo x, y
            item.emitEvent 'transitionEnd', [ item ]
            return

        if y > curY
          vaiXA = @itemWidth + @diff
          vaiXB = -@itemWidth - @diff
        else
          vaiXA = -@itemWidth - @diff
          vaiXB =  @itemWidth + @diff

        animation
          .to(item.element, latency, {
            force3D: true
            css:
              'x': vaiXA
              'clearProps': 'transform,matrix'
          })
          .set(item.element, {'x': vaiXB, 'left': x, 'top': y})
          .to(item.element, latency, {
            force3D: true
            css:
              'x': 0
              'clearProps': 'transform,matrix'
          })

    return

  return NewtonMode
