window.MELON.directive 'fileReader', ->
  'use strict'

  {
    restrict: 'AE'
    replace: true
    scope: false
    template: """
      <div>
        <input name="{{inputName}}" type="file">
      </div>
    """
    link: (scope, element, attrs) ->
      reader = if FileReader? then new FileReader() else false

      reader.onload = (evt)->
        newImgBlob = new Blob [new Int8Array(evt.target.result)] #, { type: image.type }
        newImgUrl = URL.createObjectURL newImgBlob

        scope.$apply ->
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