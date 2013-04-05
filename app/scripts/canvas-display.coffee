window.MELON.directive 'canvasDisplay', ['canvasConverter', (canvasConverter) ->
  'use strict'

  {
    restrict: 'AE'
    replace: true
    scope: false
    template: """
      <div>
        <canvas id="cd-canvas" class="cd-canvas cd-input-canvas" height="200" width="200"></canvas>
        <canvas id="cd-canvas2" ng-show="haveImage" class="cd-canvas cd-ouput-canvas" height="200" width="200"></canvas>
        <div ng-show="haveImage">
          <a ng-show="!changingPx" class="bm-link cd-change-px-link" ng-click="changingPx=true">Change Block Size (optional)</a>
          <ul ng-show="changingPx" class="cd-ranges">
            <li ng-click="changePx(px.size)" class="cd-range" ng-repeat="px in pxOptions">
              <div class="cd-range-label">{{px.size}}px</div>
              <div class="cd-range-box" style="width:{{px.style}}px"></div>
            </li>
            <li class="cd-range">
              <a class="cd-range-close" ng-click="changingPx=false">&times;</a>
            </li>
          </ul>
        </div>
        <a ng-show="haveImage" download class="bm-btn cd-save-btn">Save Blocks</a>
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

      ctx = document.getElementById('cd-canvas').getContext('2d')
      outCanvas = document.getElementById('cd-canvas2')
      ctx2 = outCanvas.getContext('2d')
      imageData = null

      pixelate = _.throttle ->
        imageData = ctx.getImageData 0, 0, 200, 200
        intPxSize = parseInt scope.pxSize, 10
        imageData = canvasConverter.pixelate imageData, intPxSize, intPxSize
        ctx2.putImageData imageData, 0, 0

        outCanvas.toBlob (blob) ->
          bloblUrl = URL.createObjectURL blob
          document.querySelector('.cd-save-btn').setAttribute 'href', bloblUrl
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