window.MELON.directive 'canvasConverter', ->
  'use strict'

  newPx = (i) ->
    i % 4 is 0

  newRow = (i, y, width) ->
    i == (4 * width) * (y + 1)
    # i > 0 && (((i * 4) * y) % (width * 4) == 0)
    # (i * (y + 1)) == ((4 * width) - 1)
    # (i * 4) >= ((y + 1) * width * 4)

  fixData = (c, width) ->
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

  breakData = (fixed, orig, width, height) ->
    i = 0
    _.each [0..(height - 1)], (y) ->
      _.each [0..(width - 1)], (x) ->
        px = fixed["#{x},#{y}"]
        if px?
          orig.data[i] = px.r
          orig.data[i + 1] = px.g
          orig.data[i + 2] = px.b
          orig.data[i + 3] = px.a
          i += 4
        else
          # swallow silently in despair
          #console.error "x,y: #{x}, #{y}"
    orig

  findColor = (pxs, startX, startY, pxWidth, pxHeight) ->
    rTotal = gTotal = bTotal = aTotal = 0
    _.each [startY..(pxHeight - 1)], (y) ->
      _.each [startX..(pxWidth - 1)], (x) ->
        px = pxs["#{x},#{y}"]
        if px?
          rTotal += px.r
          gTotal += px.g
          bTotal += px.b
          aTotal += px.a
    numPxs = pxWidth * pxHeight
    {
      r: rTotal / numPxs
      g: gTotal / numPxs
      b: bTotal / numPxs
      a: aTotal / numPxs
    }

  isStartNewBlock = (x, y, pxWidth, pxHeight) ->
    (x % pxWidth == 0) && (y % pxHeight == 0)

  pixelate = (pxs, width, height, numPxWide, numPxHigh) ->
    pxHeight = Math.ceil(height / numPxHigh)
    pxWidth = Math.ceil(width / numPxWide)

    _.each [0..(height - 1)], (y) ->
      _.each [0..(width - 1)], (x) ->
        if isStartNewBlock x, y, pxWidth, pxHeight
          color = findColor pxs, x * pxWidth, y * pxHeight, pxWidth, pxHeight
        pxs["#{x},#{y}"] = color
    pxs







    # origI = 0
    # _.each fixed, (px, i) ->
    #   orig[origI]
    #   arr.push px.r
    #   arr.push px.g
    #   arr.push px.b
    #   arr.push px.a




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

      ctx = document.getElementById('canvas').getContext('2d')

      scope.$on 'newImage', (evt, image) ->
        ctx.drawImage(image, 0, 0, 50, 50)
        imgData = ctx.getImageData(0, 0, 50, 50)

        fixed = fixData(imgData.data, 4)
        pixelated = pixelate fixed, 50, 50, 10, 10

        broken = breakData(pixelated, imgData, 50, 50)

        ctx2 = document.getElementById('canvas2').getContext('2d')
        ctx2.putImageData(imgData, 0, 0)



  }