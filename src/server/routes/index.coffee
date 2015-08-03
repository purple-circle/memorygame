'use strict'
express = require('express')
images = require('../models/images')

router = express.Router()

router.get '/', (req, res) ->
  res.render 'index',
    sid: req.sessionID


router.get '/api/get-images', (req, res) ->
  images
    .get({limit: 20})
    .then (result) ->
      res.jsonp result
      console.log "result", result


router.post '/api/save-image', (req, res) ->
  images
    .save(req.body)
    .then (result) ->
      res.jsonp result
      console.log "result", result


module.exports = router