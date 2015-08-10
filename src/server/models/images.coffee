'use strict'
mongoose = require 'mongoose'
images = {}

images.save = (data) ->
  Image = mongoose.model 'images'
  image = new Image(data)
  image.save()

images.getFromCategory = (category, limit = 20) ->
  Image = mongoose.model 'images'
  Image
    .find()
    .where('category')
    .equals(category)
    .limit(limit)
    .exec()


images.get = (limit = 20) ->
  Image = mongoose.model 'images'
  Image
    .find()
    .limit(limit)
    .exec()


module.exports = images