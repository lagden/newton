'use strict';
define('config', function() {
  requirejs.config({
    baseUrl: '/js/lib',
    paths: {
      app: '../app',
      templates: '../templates',
      support: '../support',
      TweenLite: './gsap/src/uncompressed/TweenLite',
      TimelineLite: './gsap/src/uncompressed/TimelineLite',
      CSSPlugin: './gsap/src/uncompressed/plugins/CSSPlugin'
    }
  });
});
