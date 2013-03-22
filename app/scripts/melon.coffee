window.MELON = angular.module('melon', [])
  .config ['$httpProvider', ($httpProvider) ->
    
  ]

window.MELON.controller 'MelonCtrl', ['$scope', ($scope) ->

  alert 'melons!'
  
]
