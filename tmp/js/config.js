'use strict';
define('config', function() {
  requirejs.config({
    baseUrl: '/js/lib',
    paths: {
      app: '../app',
      templates: '../templates',
      support: '../support',
      TweenMax: './gsap/src/uncompressed/TweenMax'
    }
  });
});
