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
  };
  NewtonMode.prototype._getItemLayoutPosition = function (item) {
    var containerWidth, itemWidth, position;
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
          vaiXA = item.layout.size.width - curX;
          vaiXB = -item.size.width;
        } else {
          vaiXA = -item.size.width;
          vaiXB = item.layout.size.width - x;
        }
        animation.to(item.element, duration / 2, {
          force3D: true,
          css: {
            'x': vaiXA,
            'opacity': 0,
            'clearProps': 'transform,matrix'
          }
        }).set(item.element, {
          'x': vaiXB,
          'left': x,
          'top': y
        }).to(item.element, duration / 2, {
          force3D: true,
          css: {
            'x': 0,
            'opacity': 1,
            'clearProps': 'transform,matrix,opacity'
          }
        });
      }
    }
  };
  return NewtonMode;
});