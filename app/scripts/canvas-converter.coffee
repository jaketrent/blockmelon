MELON.service 'canvasConverter', ->
  'use strict'

  {
    pixelate: (imageData) ->
      imageData = @unformatData imageData

      nw = @getAverageColor imageData, 0, 0, 24, 24
      imageData = @setColor imageData, nw, 0, 0, 24, 24

      ne = @getAverageColor imageData, 25, 0, 49, 24
      imageData = @setColor imageData, ne, 25, 0, 49, 24

      sw = @getAverageColor imageData, 0, 25, 24, 49
      imageData = @setColor imageData, sw, 0, 25, 24, 49

      # se = @getAverageColor imageData, 25, 25, 49, 49
      # imageData = @setColor imageData, se, 25, 25, 49, 49

      imageData = @reformatData imageData
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
        _.each [0..height - 1], (row, i) ->
          start = i * width
          end = start + width
          rows.push pxs.slice start, end
        rows

      pxs = mkSinglePxArray imageData
      unformattedData = mkMultiDimArray pxs, imageData.height, imageData.width
      imageData.unformattedData = unformattedData
      imageData

    reformatData: (imageData) ->
      arrOfPxArr = []

      splitPx = (px) ->
        [px.r, px.g, px.b, px.a]

      setDataAttr = (imageData, newData) ->
        _.each newData, (pt, i) ->
          imageData.data[i] = pt
        imageData

      singleDimPxObj = _.flatten imageData.unformattedData

      arrOfPxArr.push splitPx px for px in singleDimPxObj
      singleDimPxArr = _.flatten arrOfPxArr

      imageData = setDataAttr imageData, singleDimPxArr
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
      { r: rTotal / numPxs, g: gTotal / numPxs, b: bTotal / numPxs, a: 255 }
      # { r: 255, g: 0, b: 0, a: 255 }

  }