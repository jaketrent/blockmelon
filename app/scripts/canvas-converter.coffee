MELON.service 'canvasConverter', ->
  'use strict'

  {
    pixelate: (imageData) ->
      imageData

    unformatData: (imageData) ->

      newRow = (i) ->
        i % 4 is 0

      mkSinglePxArray = (imageData) ->
        pxs = []
        pts = imageData.data
        _.each pts, (pt, i) ->
          if newRow i
            pxs.push { r: pts[i], g: pts[i + 1], b: pts[i + 2], a: pts[i + 3] }
        pxs

      mkMultiDimArray = (pxs, height, width) ->
        rows = []
        _.each [0..height - 1], (row) ->
          rows.push pxs.slice 0, width
        rows

      pxs = mkSinglePxArray imageData
      unformattedData = mkMultiDimArray pxs, imageData.height, imageData.width
      imageData.unformattedData = unformattedData
      imageData

    reformatData: (imageData) ->
      arrOfPxArr = []
      splitPx = (px) ->
        [px.r, px.g, px.b, px.a]

      singleDimPxObj = _.flatten imageData.unformattedData

      arrOfPxArr.push splitPx px for px in singleDimPxObj
      singleDimPxArr = _.flatten arrOfPxArr

      imageData.reformattedData = singleDimPxArr
      imageData

    setColor: (imageData, color, sx=0, sy=0, ex=imageData.width - 1, ey=imageData.height - 1) ->
      # TODO: optimize -- return if outside box twice (x & y)
      _.each imageData.unformattedData, (row, y) =>
        _.each row, (px, x) =>
          if @isInBox x, y, sx, sy, ex, ey
            imageData.unformattedData[y][x] = color
      imageData

    isInBox: (x, y, sx, sy, ex, ey) ->
      sx <= x <= ex && sy <= y <= ey

    createBox: ->
      [0, 0, 0, 0]

    getAverageColor: (imageData, sx=0, sy=0, ex=imageData.width - 1, ey=imageData.height - 1) ->
      # TODO: optimize -- return if outside box twice (x & y)
      rTotal = 0
      gTotal = 0
      bTotal = 0
      numPxs = (ex - sx + 1) * (ey - sy + 1) #imageData.width * imageData.height
      _.each imageData.unformattedData, (row, y) =>
        _.each row, (px, x) =>
          if @isInBox x, y, sx, sy, ex, ey
            rTotal += px.r
            gTotal += px.g
            bTotal += px.b
      { r: rTotal / numPxs, g: gTotal / numPxs, b: bTotal / numPxs, a: 1 }

  }