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
        <div ng-show="haveImage" class="cc-range">
          <div class="cc-range-val">{{pxSize}}px</div>
          <span class="cc-range-label">10px</span>
          <input ng-change="changePxSize()" ng-model="pxSize" class="cc-range-slider" type="range" min="10" max="100" step="10" />
          <span class="cc-range-label">100px</span>
        </div>
        <a ng-show="haveImage" download class="btn bm-btn cc-save-btn">Save Blocks</a>
      </div>
    """
    link: (scope, element, attrs) ->

      scope.haveImage = false
      scope.pxSize = 20

      ctx = document.getElementById('cc-canvas').getContext('2d')
      outCanvas = document.getElementById('cc-canvas2')
      ctx2 = outCanvas.getContext('2d')
      imageData = null

      pixelate = _.throttle ->
        imageData = ctx.getImageData 0, 0, 200, 200
        intPxSize = parseInt scope.pxSize, 10
        imageData = canvasConverter.pixelate imageData, intPxSize, intPxSize
        ctx2.putImageData imageData, 0, 0

        outCanvas.toBlob (blob) ->
          bloblUrl = URL.createObjectURL blob
          document.querySelector('.cc-save-btn').setAttribute 'href', bloblUrl
        , "image/jpeg", {
          maxH: 200
          maxW: 200
          quality: .8
        }

      , 200

      scope.changePxSize = ->
        if scope.haveImage
          pixelate()

      scope.$on 'newImage', (evt, image) ->
        ctx.drawImage image, 0, 0, 200, 200

        pixelate()

        scope.$apply ->
          scope.haveImage = true


  }
]