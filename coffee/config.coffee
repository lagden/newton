'use strict'

define 'config', ->
  requirejs.config
    baseUrl: '/js/lib'
    paths:
      app: '../app'
      templates: '../templates'

  return
