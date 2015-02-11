'use strict';
define(['app/explode', 'isotope/js/isotope', 'support/newton', 'jquery', 'jquery-bridget/jquery.bridget'], function(explode, Isotope, NewtonMode, $) {
  var $c, $items, $itemsContent, explodeAll, grow, opts;
  $.bridget('isotope', Isotope);
  opts = {
    itemSelector: '.item',
    isResizeBound: true,
    isInitLayout: true,
    transitionDuration: '0.6s',
    layoutMode: 'newtonMode',
    sortBy: ['number'],
    getSortData: {
      number: '[data-pos] parseInt'
    }
  };
  $c = $('#container');
  $c.isotope(opts);
  grow = function(event) {
    var $item, $parent;
    $item = $(event.currentTarget);
    $parent = $item.parent();
    $parent.toggleClass('item_grow');
    $c.isotope('layout');
  };
  explodeAll = function(event) {
    var item, _i, _len;
    event.preventDefault();
    event.stopPropagation();
    $c.isotope('destroy');
    for (_i = 0, _len = $items.length; _i < _len; _i++) {
      item = $items[_i];
      explode(item);
    }
  };
  $itemsContent = $c.find('> .item > .item__content');
  $itemsContent.on('click', grow);
  $items = $c.find('> .item');
  $items.filter('.item_explode').on('click', explodeAll);
});
