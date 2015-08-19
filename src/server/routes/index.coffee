'use strict'
express = require('express')
images = require('../models/images')

router = express.Router()

router.get '/', (req, res) ->
  res.render 'index',
    sid: req.sessionID


router.get '/api/get-images', (req, res) ->
  images
    .get(limit)
    .then (result) ->
      res.jsonp result


router.post '/api/save-image', (req, res) ->
  images
    .save(req.body)
    .then (result) ->
      res.jsonp result


module.exports = router