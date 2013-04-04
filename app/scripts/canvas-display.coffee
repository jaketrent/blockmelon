window.MELON.directive 'canvasDisplay', ['canvasConverter', (canvasConverter) ->
  'use strict'

  {
    restrict: 'AE'
    replace: true
    scope: false
    template: """
      <div>
        <canvas id="cc-canvas" class="cc-canvas cc-input-canvas" height="200" width="200"></canvas>
        <canvas id="cc-canvas2" ng-show="haveImage" class="cc-canvas cc-ouput-canvas" height="200" width="200"></canvas>
      </div>
    """
    link: (scope, element, attrs) ->

      scope.haveImage = false

      ctx = document.getElementById('cc-canvas')?.getContext('2d')
      ctx2 = document.getElementById('cc-canvas2')?.getContext('2d')

      scope.$on 'newImage', (evt, image) ->
        scope.$apply ->
          scope.haveImage = true
        console.log scope.haveImage
        console.log scope
        ctx.drawImage image, 0, 0, 200, 200
        imageData = ctx.getImageData 0, 0, 200, 200

        imageData = canvasConverter.pixelate imageData, 10, 10
        ctx2.putImageData imageData, 0, 0
  }
]