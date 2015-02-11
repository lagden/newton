'use strict';
define(['outlayer/outlayer', 'isotope/js/layout-mode', 'TweenMax'], function(Outlayer, LayoutMode, TM) {
  var NewtonMode, NewtonOutlayer, extend;
  extend = function(a, b) {
    var prop;
    for (prop in b) {
      a[prop] = b[prop];
    }
    return a;
  };
  NewtonOutlayer = Outlayer.create('newtonOutlayer');
  NewtonOutlayer.prototype._resetLayout = function() {
    this.x = 0;
    this.y = 0;
    this.maxY = 0;
    this._getMeasurement('gutter', 'outerWidth');
  };
  NewtonOutlayer.prototype._getItemLayoutPosition = function(item) {
    var containerWidth, itemWidth, position;
    console.trace();
    item.getSize();
    itemWidth = item.size.outerWidth + this.gutter;
    containerWidth = this.isotope.size.innerWidth + this.gutter;
    if (this.x !== 0 && itemWidth + this.x > containerWidth) {
      this.x = 0;
      this.y = this.maxY;
    }
    position = {
      x: this.x,
      y: this.y
    };
    this.maxY = Math.max(this.maxY, this.y + item.size.outerHeight);
    this.x += itemWidth;
    return position;
  };
  NewtonOutlayer.prototype._getContainerSize = function() {
    return {
      height: this.maxY
    };
  };
  NewtonOutlayer.prototype._positionItem = function(item, x, y, isInstant) {
    var current;
    if (isInstant) {
      item.goTo(x, y);
    } else {
      current = {
        x: item.element.style.left,
        y: item.element.style.top
      };
      if (current.y !== y) {
        item.goTo(x, y);
      } else {
        item.moveTo(x, y);
      }
    }
  };
  NewtonMode = LayoutMode.create('newtonMode');
  extend(NewtonMode.prototype, NewtonOutlayer.prototype);
  return NewtonMode;
});
