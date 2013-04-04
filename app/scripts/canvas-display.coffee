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
        <div ng-show="haveImage">
          <a ng-show="!changingPx" class="bm-link cc-change-px-link" ng-click="changingPx=true">Change Block Size (optional)</a>
          <ul ng-show="changingPx" class="cc-ranges">
            <li ng-click="changePx(px.size)" class="cc-range" ng-repeat="px in pxOptions">
              <div class="cc-range-label">{{px.size}}px</div>
              <div class="cc-range-box" style="width:{{px.style}}px"></div>
            </li>
            <li class="cc-range">
              <a class="cc-range-close" ng-click="changingPx=false">&times;</a>
            </li>
          </ul>
        </div>
        <a ng-show="haveImage" download class="btn bm-btn cc-save-btn">Save Blocks</a>
      </div>
    """
    link: (scope, element, attrs) ->

      scope.haveImage = false
      scope.pxSize = 20
      scope.pxOptions = [
        { size: 5, style: 20 }
        { size: 10, style: 25 }
        { size: 20, style: 40 }
        { size: 40, style: 50 }
        { size: 100, style: 60 }
      ]

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

      scope.changePx = (size) ->
        scope.pxSize = size
        if scope.haveImage
          pixelate()

      scope.$on 'newImage', (evt, image) ->
        ctx.drawImage image, 0, 0, 200, 200

        pixelate()

        scope.$apply ->
          scope.haveImage = true


  }
]