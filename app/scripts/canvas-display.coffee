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
        <img id="cc-img" ng-show="haveImage" />
        <button ng-show="haveImage" ng-click="save" class="btn bm-btn cc-save-btn">Save Blocks</button>

      </div>
    """
    link: (scope, element, attrs) ->

      scope.haveImage = false

      ctx = document.getElementById('cc-canvas').getContext('2d')
      outCanvas = document.getElementById('cc-canvas2')
      ctx2 = outCanvas.getContext('2d')

      scope.save = ->
        # outCanvas.toBlob ->
        #   # TODO: impl save to image tag for save
        # , 'image/jpeg', {
        #   maxH: 200
        #   maxW: 200
        #   quality: .8
        # }

      scope.$on 'newImage', (evt, image) ->
        console.log scope.haveImage
        console.log scope
        ctx.drawImage image, 0, 0, 200, 200
        imageData = ctx.getImageData 0, 0, 200, 200

        imageData = canvasConverter.pixelate imageData, 5, 5
        ctx2.putImageData imageData, 0, 0
        scope.$apply ->
          scope.haveImage = true

  }
]