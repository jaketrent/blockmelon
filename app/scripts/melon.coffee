window.MELON = angular.module('melon', [])

MELON.controller 'MelonCtrl', ['$scope', ($scope) ->

  $scope.image =
    src: "images/nacho.jpg"

  # $scope.$on 'newImage', (evt, args) ->
  #   console.log 'new image'

    # put image into canvas


]
