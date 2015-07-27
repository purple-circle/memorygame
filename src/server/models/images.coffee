'use strict'
mongoose = require 'mongoose'
images = {}

images.save = (data) ->
  Image = mongoose.model 'images'
  image = new Image(data)
  image.save()

module.exports = images