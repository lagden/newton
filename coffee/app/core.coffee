'use strict'

define [
    'app/explode'
    'isotope/js/isotope'
    'support/newton'
    'jquery'
    'jquery-bridget/jquery.bridget'

], (explode, Isotope, NewtonMode, $) ->

  Isotope.LayoutMode = NewtonMode

  $.bridget 'isotope', Isotope

  opts =
    itemSelector: '.item'
    transitionDuration: '0.6s'
    layoutMode: 'newtonMode'
    sortBy: ['number']
    getSortData:
      number: '[data-pos] parseInt'

  isGrowing = false

  $c = $ '#container'
  $c.isotope opts
  $c.isotope 'on', 'layoutComplete', ->
    isGrowing = false

  grow = (event) ->
    if isGrowing is false
      isGrowing = true
      $item = $ event.currentTarget
      $parent = $item.parent()
      $parent.toggleClass 'item_grow'
      $c.isotope()
    return

  explodeAll = (event) ->
    event.preventDefault()
    event.stopPropagation()
    $c.isotope 'destroy'
    explode item for item in $items
    return

  $itemsContent = $c.find '> .item:not(.item_explode) > .item__content'
  $itemsContent.on 'click', grow

  $items = $c.find '> .item'
  $items.filter('.item_explode').on 'click', explodeAll

  # Test isotope
  window.$c = $c

  return
