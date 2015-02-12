Newton Mode
===========

Isotope Layout

## TODO

- [x] Fork no isotope
- [x] add no `layout-mode.js` na linha 32 - `'_positionItem',`
- [x] no `isotope.js` na linha 450

```javascript
Isotope.prototype._positionItem = function(item, x, y, isInstant) {
  return this._mode()._positionItem(item, x, y, isInstant);
};
```

- [x] trocar o bower para lagden/isotope
- [x] Teste da animação usando GSAP

## Author

- [Thiago Lagden](https://github.com/lagden)
