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

        scope.$apply ->
          scope.image = _.extend scope.image,
            url: URL.createObjectURL newImgBlob
            name: newImgBlob.name

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