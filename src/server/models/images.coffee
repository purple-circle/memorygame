'use strict'
mongoose = require 'mongoose'
images = {}

images.save = (data) ->
  Image = mongoose.model 'images'
  image = new Image(data)
  image.save()

images.get = (limit = 20) ->
  Image = mongoose.model 'images'
  Image
    .find()
    .limit(limit)
    .exec()


module.exports = images