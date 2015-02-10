'use strict'

define [
    'isotope/js/isotope'
    'jquery'
    'jquery-bridget/jquery.bridget'
], (Isotope, $) ->

  $.bridget 'isotope', Isotope

  opts =
    itemSelector: '.item'
    isResizeBound: true
    isInitLayout: true
    transitionDuration: '0.6s'
    layoutMode: 'fitRows'
    sortBy: ['number']
    getSortData:
      number: '[data-pos] parseInt'

  # $c = $ '#container'
  # $c.isotope opts

  grow = (event) ->
    console.log event.currentTarget
    $item = $ event.currentTarget
    $parent = $item.parent()
    $parent.toggleClass 'item_grow'
    # $c.isotope 'layout'
    return

  $items = $c.find '> .item > .item__content'
  $items.on 'click', grow

  return
