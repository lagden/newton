'use strict'

define [
    'app/explode'
    'isotope/js/isotope'
    'support/newton'
    'jquery'
    'jquery-bridget/jquery.bridget'

], (explode, Isotope, NewtonMode, $) ->

  # Isotope.LayoutMode = NewtonMode

  # console.log NewtonMode

  $.bridget 'isotope', Isotope

  opts =
    itemSelector: '.item'
    isResizeBound: true
    isInitLayout: true
    transitionDuration: '0.6s'
    layoutMode: 'newtonMode'
    sortBy: ['number']
    getSortData:
      number: '[data-pos] parseInt'

  $c = $ '#container'
  $c.isotope opts

  grow = (event) ->
    $item = $ event.currentTarget
    $parent = $item.parent()
    $parent.toggleClass 'item_grow'
    $c.isotope 'layout'
    return

  explodeAll = (event) ->
    event.preventDefault()
    event.stopPropagation()
    $c.isotope 'destroy'
    explode item for item in $items
    return

  $itemsContent = $c.find '> .item > .item__content'
  $itemsContent.on 'click', grow

  $items = $c.find '> .item'
  $items.filter('.item_explode').on 'click', explodeAll

  return
