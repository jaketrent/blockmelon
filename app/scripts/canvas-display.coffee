window.MELON.directive 'canvasDisplay', ['canvasConverter', (canvasConverter) ->
  'use strict'

  {
    restrict: 'AE'
    replace: true
    scope: false
    template: """
      <div>
        <canvas id="canvas" height="50" width="50"></canvas>
        <canvas id="canvas2" height="50" width="50"></canvas>
      </div>
    """
    link: (scope, element, attrs) ->

      ctx = document.getElementById('canvas')?.getContext('2d')
      ctx2 = document.getElementById('canvas2')?.getContext('2d')

      scope.$on 'newImage', (evt, image) ->
        ctx.drawImage(image, 0, 0, 50, 50)
        imageData = ctx.getImageData(0, 0, 50, 50)

        imageData = canvasConverter.pixelate imageData
        ctx2.putImageData imageData, 0, 0
  }
]