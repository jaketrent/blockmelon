describe 'canvasConverter', ->

  assert = chai.assert
  expect = chai.expect
  should = chai.should()

  cc = null
  ctx = null

  fixtureHtml = """
    <canvas id="canvas" height="50" width="50"></canvas>
  """

  beforeEach angular.mock.inject (_canvasConverter_) ->
    cc = _canvasConverter_

  beforeEach ->
    document.querySelector('body').innerHTML = fixtureHtml
    ctx = document.querySelector('#canvas').getContext '2d'

  it 'should be injectable', ->
    cc.should.not.be.undefined

  describe '#pixelate', ->

    it 'takes and returns ImageData of the same size', ->
      imageData = ctx.createImageData(50,50)
      imageDataOut = cc.pixelate imageData
      imageDataOut.height.should.eq 50
      imageDataOut.width.should.eq 50

  describe 'Data Formatting', ->

    imageData = null

    it '#unformatData creates a multidimensional array', ->
      imageData = ctx.createImageData(50,50)
      imageData.data.length.should.eq (50 * 50 * 4)
      imageData = cc.unformatData imageData

      imageData.unformattedData.length.should.eq 50
      row.length.should.eq 50 for row in imageData.unformattedData

    it '#reformatData creates a singledimensional array', ->
      # relies on previous test having run already
      originalData = imageData.data
      imageData = cc.reformatData imageData
      imageData.data.length.should.eq (50 * 50 * 4)
      _.each imageData.data, (pt, i) ->
        pt.should.eq originalData[i]
      # TODO: determine why this won't work
      # imageData.reformattedData[444].should.eq imageData.data[444]

  describe 'Box Detection', ->

    it 'can determine a point is w/in specified coordinates', ->
      x = 2
      y = 2
      sx = 0
      sy = 0
      ex = 4
      ey = 4
      expect(cc.isInBox x, y, sx, sy, ex, ey).to.be.true

    it 'can determine a point is outside specified coordinates', ->
      x = 1
      y = 5
      sx = 0
      sy = 0
      ex = 4
      ey = 4
      expect(cc.isInBox x, y, sx, sy, ex, ey).to.be.false

  describe 'Color Setting', ->

    imageData = null

    beforeEach ->
      imageData = ctx.createImageData(50, 50) #creates 50 x 50 black, alpha 0 image
      imageData = cc.unformatData imageData

    it 'sets color over a whole image', ->
      color = { r: 255, g: 255, b: 255, a: 255 }
      imageData = cc.setColor imageData, color

      color.should.eq coloredPx for coloredPx in _.flatten imageData.unformattedData

    it 'sets color over a specified region', ->
      color = { r: 255, g: 255, b: 255, a: 255 }
      defaultColor = { r: 0, g: 0, b: 0, a: 0 }
      sx = 0
      sy = 0
      ex = 24
      ey = 24
      imageData = cc.setColor imageData, color, sx, sy, ex, ey

      _.each imageData.unformattedData, (row, y) ->
        _.each row, (px, x) ->
          if cc.isInBox x, y, sx, sy, ex, ey
            color.should.eq px
          else
            defaultColor.r.should.eq px.r
            defaultColor.g.should.eq px.g
            defaultColor.b.should.eq px.b
            defaultColor.a.should.eq px.a
            # TODO: determine why this fails
            # defaultColor.should.eq px

  describe 'Color Averaging', ->

    imageData = null

    beforeEach ->
      imageData = ctx.createImageData(50, 50) #creates 50 x 50 black, alpha 0 image
      imageData = cc.unformatData imageData
      white = { r: 255, g: 255, b: 255, a: 255 }
      sx = 0
      sy = 0
      ex = 24
      ey = 24
      imageData = cc.setColor imageData, white, sx, sy, ex, ey

    it 'can find color average of whole image', ->
      # black 3 quads, white 1 quad
      # (255+0+0+0)/4 = 63.75 for all r, g, b
      lightGray = { r: 63.75, g: 63.75, b: 63.75, a: 255 }
      color = cc.getAverageColor imageData
      color.r.should.eq lightGray.r
      color.g.should.eq lightGray.g
      color.b.should.eq lightGray.b
      color.a.should.eq lightGray.a
      # TODO: determine why won't this work
      # color.should.eq lightGray

    it 'can find color average over a specified region', ->
      # black 3 quads, white 1 quad
      # but just look at the region across 1 black and 1 white quad
      # ((255*12)+(0*12))/(12+12) = 127.5 for all r, g, b
      moreGray = { r: 127.5, g: 127.5, b: 127.5, a:255 }
      sx = 12
      sy = 0
      ex = 37
      ey = 24
      color = cc.getAverageColor imageData, sx, sy, ex, ey
      color.r.should.eq moreGray.r
      color.g.should.eq moreGray.g
      color.b.should.eq moreGray.b
      color.a.should.eq moreGray.a
      # TODO: determine why won't this work
      # color.should.eq moreGray
