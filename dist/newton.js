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
  };
  NewtonMode.prototype._getItemLayoutPosition = function (item) {
    var containerWidth, itemWidth, position;
    item.getSize();
    itemWidth = item.size.outerWidth + this.gutter;
    containerWidth = this.isotope.size.innerWidth + this.gutter;
    this.itemWidth = Math.max(this.itemWidth, itemWidth);
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
    var animation, compareX, compareY, curX, curY, didNotMove, duration, vaiXA, vaiXB;
    if (isInstant) {
      item.goTo(x, y);
    } else {
      item.getPosition();
      curX = item.position.x;
      curY = item.position.y;
      compareX = parseInt(x, 10);
      compareY = parseInt(y, 10);
      didNotMove = compareX === item.position.x && compareY === item.position.y;
      if (item.id === 26) {
        console.log(curX, x, this.itemWidth);
      }
      item.setPosition(x, y);
      if (didNotMove && item.isTransitioning) {
        item.layoutPosition();
        return;
      }
      if (y === curY) {
        item.moveTo(x, y);
      } else {
        duration = parseFloat(item.layout.options.transitionDuration, 10);
        animation = new TimelineLite({
          autoRemoveChildren: true,
          smoothChildTiming: true,
          onComplete: function () {
            item.goTo(x, y);
            item.emitEvent('transitionEnd', [item]);
          }
        });
        if (y > curY) {
          vaiXA = this.itemWidth + item.size.width + 200;
          vaiXB = -this.itemWidth - item.size.width - 200;
        } else {
          vaiXA = -this.itemWidth - item.size.width - 200;
          vaiXB = this.itemWidth + item.size.width + 200;
        }
        animation.to(item.element, duration, {
          force3D: true,
          css: {
            'x': vaiXA,
            'clearProps': 'transform,matrix'
          }
        }).set(item.element, {
          'x': vaiXB,
          'left': x,
          'top': y
        }).to(item.element, duration, {
          force3D: true,
          css: {
            'x': 0,
            'clearProps': 'transform,matrix'
          }
        });
      }
    }
  };
  return NewtonMode;
});