window.MELON.directive 'imageReader', ->
  'use strict'

  {
    restrict: 'AE'
    replace: true
    scope: false
    template: """
      <div>
        <button class="bm-btn ir-choose-btn" ng-show="isChoosing" ng-click="choose()">Choose Image</button>
        <input class="ir-filechooser" name="{{inputName}}" type="file">
        <div ng-show="!isChoosing">
          or <a class="bm-link" ng-click="choose()">make more blocks</a>.
        </div>
      </div>
    """
    link: (scope, element, attrs) ->

      scope.isChoosing = true

      scope.choose = ->
        document.querySelector('.ir-filechooser').click()

      reader = if FileReader? then new FileReader() else false

      reader.onload = (evt)->
        scope.isChoosing = false
        newImgBlob = new Blob [new Int8Array(evt.target.result)] #, { type: image.type }
        newImgUrl = URL.createObjectURL newImgBlob

        scope.$apply ->
          console.log scope
          newImage = new Image()
          # TODO: handle resize
          newImage.src = newImgUrl
          newImage.onload = ->
            scope.image = _.extend scope.image,
              src: newImgUrl.src
              name: newImgBlob.name,
              image: newImage
            scope.$emit 'newImage', newImage

      # TODO: use angular bind?
      element.bind 'change', (evt)->
        if reader
          image = evt.target.files[0]
          return unless image
          return unless image.type.match 'image.*'
          reader.readAsArrayBuffer image
        else
          alert "This isn't going to work.  Upgrade yoru browser."

  }