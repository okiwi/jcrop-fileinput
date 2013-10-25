do ($ = jQuery, window, document) ->

  pluginName = "JCropFileInput"
  defaults =
    ratio: undefined,
    jcrop_width: "640",
    jcrop_height: "480",
    preview_height: "150",
    preview_width: "150"

  class JCropFileInput
    constructor: (@element, options) ->
      @options = $.extend({}, defaults, options)
      @_defaults = defaults
      @_name = pluginName
      @init()

    init: ->
      $(@element).on('change', @on_fileinput_change)
      @widgetContainer = $("<div>")
      @widgetContainer.addClass('jcrop-fileinput-container')
      @targetCanvas = document.createElement('canvas')
      @widgetContainer.append($(@targetCanvas))
      $(@element).after(@widgetContainer)
  
    on_fileinput_change: (evt) =>
      file = evt.target.files[0]
      reader = new FileReader()
      reader.onloadend = (evt) =>
        @original_filetype = file.type
        @original_image = @build_image(reader.result, @on_original_image_loaded)
      reader.readAsDataURL(file)

    on_original_image_loaded: (image) =>
      @original_width = image.width
      @original_height = image.height
      @resize_image(image)
      
    build_image: (image_data, callback) ->
      image = document.createElement('img')
      image.src = image_data
      image.onload = (evt) =>
        if callback
          callback(image)
      return image

    resize_image: (image) ->
      size = @get_crop_area_size(image.width, image.height)
      canvas_width = size.width
      canvas_height = size.height
      canvas = document.createElement('canvas')
      canvas.width = canvas_width
      canvas.height = canvas_height

      ctx = canvas.getContext('2d')
      ctx.drawImage(image, 0, 0, canvas_width, canvas_height)
      canvas_image_data = canvas.toDataURL(@original_filetype)
      @setup_jcrop(canvas_image_data)

    get_crop_area_size: (width, height) ->
      newWidth = width
      newHeight = height

      if width > height
        if width > @options.jcrop_width
          newHeight *= @options.jcrop_width / width
          newWidth = @options.jcrop_width
      else
        if height > @options.jcrop_height
          newWidth *= @options.jcrop_height / height
          newHeight = @options.jcrop_height
      return {width: newWidth, height: newHeight}

    setup_jcrop: (data) ->
      $img = $("<img>")
      $img.prop('src', data)
      $img.addClass('jcrop-image')
      @widgetContainer.append($img)
      $img.Jcrop({
        onChange: @on_jcrop_select,
        onSelect: @on_jcrop_select,
        aspectRatio: @options.ratio
      })

    on_jcrop_select: (coords) =>
      @crop_original_image(coords)

    crop_original_image: (coords) ->
      console.log(coords)
      console.log(@original_width, @original_height)
      factor = @original_width / @options.jcrop_width
      console.log("Factor: ", factor)
      canvas = @targetCanvas
      origin_x = coords.x * factor
      origin_y = coords.y * factor
      canvas_width = coords.w * factor
      canvas_height = coords.h * factor
      canvas.width = canvas_width
      canvas.height = canvas_height

      console.log(origin_x, origin_y, canvas_width, canvas_height)
      ctx = canvas.getContext('2d')
      ctx.drawImage(@original_image,
                    origin_x, origin_y, canvas_width, canvas_height
                    0, 0, canvas_width, canvas_height
      )

  # A really lightweight plugin wrapper around the constructor,
  # preventing against multiple instantiations
  $.fn[pluginName] = (options) ->
    @each ->
      if !$.data(@, "plugin_#{pluginName}")
        $.data(@, "plugin_#{pluginName}", new JCropFileInput(@, options))
