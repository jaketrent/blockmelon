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
            <li ng-click="changePx(5)" class="cc-range">
              <div class="cc-range-label">5px</div>
              <div class="cc-range-box" style="width:20px"></div>
            </li>
            <li ng-click="changePx(10)" class="cc-range">
              <div class="cc-range-label">10px</div>
              <div class="cc-range-box" style="width:25px"></div>
            </li>
            <li ng-click="changePx(20)" class="cc-range">
              <div class="cc-range-label">20px</div>
              <div class="cc-range-box" style="width:40px"></div>
            </li>
            <li ng-click="changePx(40)" class="cc-range">
              <div class="cc-range-label">40px</div>
              <div class="cc-range-box" style="width:50px"></div>
            </li>
            <li ng-click="changePx(100)" class="cc-range">
              <div class="cc-range-label">100px</div>
              <div class="cc-range-box" style="width:60px"></div>
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