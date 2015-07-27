'use strict'
express = require('express')

images = require('../models/images')

router = express.Router()

router.get '/', (req, res) ->
  res.render 'index', {
    sid: req.sessionID
  }

router.post '/api/save-image', (req, res) ->
  images
    .save(req.body)
    .then (result) ->
      console.log "result", result


module.exports = router