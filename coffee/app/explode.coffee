### global define ###

'use strict'

define [
  'TweenLite'
], (Tween, $) ->

  explode = (item) ->

    Tween.set item,
      transformPerspective: 600
      opacity: 1
      float: 'left'
      position: 'relative'

    Tween.to item, 2,
      force3D: true
      x: parseInt Math.random() * 1000, 10
      y: parseInt Math.random() * 1000, 10
      z: parseInt Math.random() * 1000, 10
      rotation: parseInt Math.random() * 1000, 10
      rotationX: parseInt Math.random() * 1000, 10
      rotationY: parseInt Math.random() * 1000, 10
      opacity: 0
      onComplete: ->
        item.remove()

    return
