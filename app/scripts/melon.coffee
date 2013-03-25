window.MELON = angular.module('melon', [])
  .config ['$httpProvider', ($httpProvider) ->
    
  ]

window.MELON.controller 'MelonCtrl', ['$scope', ($scope) ->

  $scope.image = 
    url: "images/nacho.jpg"
  

  
]
