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

    if @pairs % 2
      console.log 'Not enough pairs to go around'
      return false
    @createBoard()

  createBoard: ->
    if !@inited
      console.log 'Run init'
      return false

    @board = []
    i = 0
    while i < @options.boardSize[0]
      row = []
      u = 0
      while u < @options.boardSize[1]
        row.push @getFreeCard()
        u++
      @board.push row
      i++
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
            return
          memo
        , []
        .sort (a, b) -> a - b

    notFound = false
    notEnoughPairs = false
    i = @options.minimumCard
    while i <= @pairs
      if flatten.indexOf(i) == -1
        notFound = i
      if @cards[i] < 2
        notEnoughPairs = true
      i++
    if notEnoughPairs
      return false
    if flatten.length / 2 != @pairs
      return false
    if notFound
      return false
    true

  getFreeCard: ->
    card = @random(@options.minimumCard, @pairs)
    if @cards[card] == 2
      return @getFreeCard()

    if !@cards[card]
      @cards[card] = 0
    @cards[card]++
    card

  checkCard: (row, card) ->
    @board[row][card]

  checkMatches: (data) ->
    # Both selections can't be for the same card
    if data[0][0] == data[1][0]
      if data[0][1] == data[1][1]
        return false

    card1 = @checkCard(data[0][0], data[0][1])
    card2 = @checkCard(data[1][0], data[1][1])

    if card1 == null or card2 == null
      return false

    card1 == card2

  removeCard: (data) ->
    if !@removed[data[0]]
      @removed[data[0]] = {}
    @removed[data[0]][data[1]] = @board[data[0]][data[1]]
    @board[data[0]][data[1]] = null
    return

  extend: ->
    extended = {}
    for key of arguments
      argument = arguments[key]
      for prop of argument
        if Object::hasOwnProperty.call(argument, prop)
          extended[prop] = argument[prop]

    extended

if module?
  module.exports = board

if window?
  window.board = board
