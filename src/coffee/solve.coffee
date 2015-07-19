board = require('./board')
options = boardSize: [10, 10]
gameBoard = board.init(options)
boardIsValid = board.validateBoard(gameBoard)
memory = {}

getRandomNotRemoved = ->
  first = board.random(0, board.options.boardSize[0] - 1)
  second = board.random(0, board.options.boardSize[1] - 1)
  value = [first, second]
  if board.removed[value[0]]?[value[1]]
    return getRandomNotRemoved()
  value

success = 0

checkLoopMatches = ->
  first = getRandomNotRemoved()
  firstCard = board.checkCard(first[0], first[1])
  if memory[firstCard]
    if !board.removed[first[0]] or !board.removed[first[0]]?[first[1]]
      second = memory[firstCard]

  if !second
    second = getRandomNotRemoved()

  isMatch = board.checkMatches([first, second])
  secondCard = board.checkCard(second[0], second[1])
  memory[firstCard] = first
  memory[secondCard] = second

  if isMatch
    board.removeCard first
    board.removeCard second
    success++

randomLoops = 100
for i in [0..randomLoops]
  checkLoopMatches()


successRate = (success / randomLoops * 100).toFixed(2)

console.log 'removed cards', board.removed
console.log 'gameBoard', gameBoard
console.log 'pairs', board.pairs
console.log 'boardIsValid', boardIsValid
console.log 'random guess success rate', successRate
