module.exports = (settings) ->
  mongoose = require('mongoose')

  imageSchema = mongoose.Schema {
    url: 'String'
    metadata: 'Object'
    created: { type: Date, default: Date.now }
    random: {type: [Number], index: '2d', default: -> return [Math.random(), Math.random()]}
  }

  mongoose.model 'images', imageSchema


  db = mongoose.connection

  db.on 'error', (error) ->
    console.log 'Mongodb returned error: %s', error

  db.on 'disconnected', ->
    console.log 'Mongodb connection disconnected'

  mongoose.connect 'localhost', settings.db
