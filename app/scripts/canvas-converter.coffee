window.MELON.directive 'canvasConverter', ->
  'use strict'

  newPx = (i) ->
    i % 4 is 0

  newRow = (i, y, width) ->
    i == (4 * width) * (y + 1)
    # i > 0 && (((i * 4) * y) % (width * 4) == 0)
    # (i * (y + 1)) == ((4 * width) - 1)
    # (i * 4) >= ((y + 1) * width * 4)

  fixData = (imgData, width) ->
    fixed = {}
    x = y = 0

    _.each c, (px, i) ->
      # console.log 'i'
      if newRow i, y, width
        # console.log 'new row!'
        ++y
        x = 0

      if newPx(i)
        # console.log 'newpx'
        fixed["#{x},#{y}"] = { r: c[i], g: c[i + 1], b: c[i + 2], a: c[i + 3] }
        ++x

    fixed

  # breakData = (fixed, orig, width, height) ->
  #   i = 0
  #   _.each [0..(height - 1)], (y) ->
  #     _.each [0..(width - 1)], (x) ->
  #       px = fixed["#{x},#{y}"]
  #       if px?
  #         orig.data[i] = px.r
  #         orig.data[i + 1] = px.g
  #         orig.data[i + 2] = px.b
  #         orig.data[i + 3] = px.a
  #         i += 4
  #       else
  #         # swallow silently in despair
  #         #console.error "x,y: #{x}, #{y}"
  #   orig

  # findColor = (pxs, startX, startY, pxWidth, pxHeight) ->
  #   rTotal = gTotal = bTotal = aTotal = 0
  #   _.each [startY..(startY + pxHeight - 1)], (y) ->
  #     _.each [startX..(startX + pxWidth - 1)], (x) ->
  #       px = pxs["#{x},#{y}"]
  #       if px?
  #         rTotal += px.r
  #         gTotal += px.g
  #         bTotal += px.b
  #         #aTotal += px.a
  #   numPxs = pxWidth * pxHeight
  #   px = {
  #     r: rTotal / numPxs
  #     g: gTotal / numPxs
  #     b: bTotal / numPxs
  #     a: 1 #aTotal / numPxs
  #   }
  #   console.log px
  #   px

  # isStartNewBlock = (x, y, pxWidth, pxHeight) ->
  #   #(x == 0 && y == 0) || ((x + 1) % pxWidth == 0) && ((y + 1) % pxHeight == 0)
  #   # testing values:
  #   (x == 0 && y == 0) || (x == 25 && y == 0) || (x == 0 && y == 25) || (x == 25 && y == 25)

  # pixelate = (pxs, width, height, numPxWide, numPxHigh) ->
  #   pxHeight = Math.ceil(height / numPxHigh)
  #   pxWidth = Math.ceil(width / numPxWide)

  #   _.each [0..(height - 1)], (y) ->
  #     _.each [0..(width - 1)], (x) ->
  #       if isStartNewBlock x, y, pxWidth, pxHeight
  #         console.log 'start new block'
  #         color = findColor pxs, x * pxWidth, y * pxHeight, pxWidth, pxHeight
  #       pxs["#{x},#{y}"] = {r:100, g:100, b:100, a:1} #color
  #   pxs

  # fakeColor = (imgData, width, height, px) ->
  #   console.log "imgData data len: #{imgData.data.length}"
  #   _.each imgData.data, (data, i) ->
  #     if newPx i
  #       imgData.data[i] = px.r
  #       imgData.data[i + 1] = px.g
  #       imgData.data[i + 2] = px.b
  #       imgData.data[i + 3] = px.a
  #   console.log imgData.data[9000]
  #   imgData


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

      scope.$on 'newImage', (evt, image) ->
        ctx.drawImage(image, 0, 0, 50, 50)
        imgData = ctx.getImageData(0, 0, 50, 50)

        console.log 'imgData'
        console.log imgData

        fixed = fixData(imgData.data, 4)
        # # pixelated = pixelate fixed, 50, 50, 25, 25
        # pixelated = fakeColor ctx.createImageData(50, 50), 50, 50, { r:0, g:0, b:0, a:1 }

        # #broken = breakData(pixelated, imgData, 50, 50)

        # ctx2 = document.getElementById('canvas2').getContext('2d')
        # ctx2.putImageData(pixelated, 0, 0)



  }