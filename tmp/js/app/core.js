'use strict';
define(['isotope/js/isotope', 'jquery', 'jquery-bridget/jquery.bridget'], function(Isotope, $) {
  var $items, grow, opts;
  $.bridget('isotope', Isotope);
  opts = {
    itemSelector: '.item',
    isResizeBound: true,
    isInitLayout: true,
    transitionDuration: '0.6s',
    layoutMode: 'fitRows',
    sortBy: ['number'],
    getSortData: {
      number: '[data-pos] parseInt'
    }
  };
  grow = function(event) {
    var $item, $parent;
    console.log(event.currentTarget);
    $item = $(event.currentTarget);
    $parent = $item.parent();
    $parent.toggleClass('item_grow');
  };
  $items = $c.find('> .item > .item__content');
  $items.on('click', grow);
});
