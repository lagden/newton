'use strict';
define(['app/explode', 'isotope/js/isotope', 'support/newton', 'jquery', 'jquery-bridget/jquery.bridget'], function(explode, Isotope, NewtonMode, $) {
  var $c, $items, $itemsContent, explodeAll, grow, isGrowing, opts;
  Isotope.LayoutMode = NewtonMode;
  $.bridget('isotope', Isotope);
  opts = {
    itemSelector: '.item',
    transitionDuration: '0.4s',
    layoutMode: 'newtonMode',
    sortBy: ['number'],
    getSortData: {
      number: '[data-pos] parseInt'
    }
  };
  isGrowing = false;
  $c = $('#container');
  $c.isotope(opts);
  $c.isotope('on', 'layoutComplete', function() {
    return isGrowing = false;
  });
  grow = function(event) {
    var $item, $parent;
    if (isGrowing === false) {
      isGrowing = true;
      $item = $(event.currentTarget);
      $parent = $item.parent();
      $parent.toggleClass('item_grow');
      $c.isotope();
    }
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
  $itemsContent = $c.find('> .item:not(.item_explode) > .item__content');
  $itemsContent.on('click', grow);
  $items = $c.find('> .item');
  $items.filter('.item_explode').on('click', explodeAll);
  window.$c = $c;
});
