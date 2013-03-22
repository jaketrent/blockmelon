require.config
  paths:
    jquery: '../components/jquery/jquery'
    bootstrap: 'vendor/bootstrap'
  shim: 
    bootstrap:
      deps: ['jquery']
      exports: 'jquery'

require ['app', 'jquery', 'bootstrap'], (app, $) ->
  'use strict'
  # use app here
  
  console.log('Running jQuery %s', $().jquery)
