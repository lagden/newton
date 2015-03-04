'use strict';
define([
  'isotope/js/layout-mode',
  'TimelineLite',
  'CSSPlugin'
], function (LayoutMode, TimelineLite) {
  var NewtonMode;
  NewtonMode = LayoutMode.create('newtonMode');
  NewtonMode.prototype._resetLayout = function () {
    this.x = 0;
    this.y = 0;
    this.maxY = 0;
    this._getMeasurement('gutter', 'outerWidth');
    this.itemWidth = 0;
    this.diff = 0;
  };
  NewtonMode.prototype._getItemLayoutPosition = function (item) {
    var containerWidth, itemWidth, position;
    item.getSize();
    itemWidth = item.size.outerWidth + this.gutter;
    containerWidth = this.isotope.size.innerWidth + this.gutter;
    this.itemWidth = Math.max(this.itemWidth, itemWidth);
    this.diff = window.innerWidth - containerWidth;
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
  NewtonMode.prototype._getContainerSize = function () {
    return { height: this.maxY };
  };
  NewtonMode.prototype._positionItem = function (item, x, y, isInstant) {
    var compareX, compareY, curX, curY, didNotMove;
    if (isInstant) {
      item.goTo(x, y);
    } else {
      item.getPosition();
      curX = item.position.x;
      curY = item.position.y;
      compareX = parseInt(x, 10);
      compareY = parseInt(y, 10);
      didNotMove = compareX === item.position.x && compareY === item.position.y;
      item.setPosition(x, y);
      if (didNotMove && item.isTransitioning) {
        item.layoutPosition();
        return;
      }
      if (y === curY || x === curX) {
        item.moveTo(x, y);
      } else {
        item.goTo(x, y);
      }
    }
  };
  return NewtonMode;
});