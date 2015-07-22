Board = ->
  board =
    options:
      minimumCard: 1
      boardSize: [10, 10]
    cards: {}
    removed: {}
    pairs: 0
    board: []
    inited: false
    init: (options) ->
      if options
        @options = @extend(@options, options)

      @inited = true
      @calculatePairs()

      # TODO: fix
      if @pairs % 2
        console.log 'Not enough pairs to go around'
        return false

      @createBoard()

    createBoard: ->
      if !@inited
        console.log 'Run init'
        return false

      rows = @options.boardSize[0] - 1
      cardsPerRow = @options.boardSize[1] - 1

      @board = []
      for i in [0..rows]
        row = []
        for u in [0..cardsPerRow]
          row.push @getFreeCard()
        @board.push row

      @board

    calculatePairs: ->
      @pairs = @options.boardSize[0] * @options.boardSize[1] / 2

    random: (min, max) ->
      min + Math.round(Math.random() * (max - min))

    validateBoard: (board) ->
      if !@pairs
        return false

      flatten =
        @board
          .reduce (memo, row) ->
            row.forEach (item) ->
              memo.push item
            memo
          , []
          .sort (a, b) -> a - b

      notFound = false
      notEnoughPairs = false

      for i in [@options.minimumCard..@pairs]
        if flatten.indexOf(i) is -1
          notFound = i
        if @cards[i] < 2
          notEnoughPairs = true

      if notEnoughPairs
        return false

      if flatten.length / 2 isnt @pairs
        return false

      if notFound
        return false

      true

    getFreeCard: ->
      card = @random(@options.minimumCard, @pairs)
      if @cards[card] is 2
        return @getFreeCard()

      @cards[card] ?= 0
      @cards[card]++
      card

    checkCard: (row, card) ->
      @board[row][card]

    checkMatches: (data) ->
      # Both selections can't be for the same card
      if data[0][0] is data[1][0]
        if data[0][1] is data[1][1]
          return false

      card1 = @checkCard(data[0][0], data[0][1])
      card2 = @checkCard(data[1][0], data[1][1])

      if !card1? or !card2?
        return false

      card1 is card2

    removeCard: (data) ->
      @removed[data[0]] ?= {}

      @removed[data[0]][data[1]] = @board[data[0]][data[1]]
      @board[data[0]][data[1]] = null

    extend: ->
      extended = {}
      for key of arguments
        argument = arguments[key]
        for prop of argument
          if Object::hasOwnProperty.call(argument, prop)
            extended[prop] = argument[prop]

      extended

if module?
  module.exports = Board

if window?
  window.Board = Board
