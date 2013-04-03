describe 'MELON.directives.canvasConverter', ->

  assert = chai.assert
  expect = chai.expect
  should = chai.should()

  elm = null

  beforeEach inject ($rootScope, $compile)->
    scope = $rootScope

    elm = angular.element """
      <canvas-converter></canvas-converter>
    """

    $compile(elm)(scope)
    scope.$digest()

  it 'should not be undefined', ->
    elm.should.not.be.undefined



