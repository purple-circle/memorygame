var board = require("./board");


var gameBoard = board.createBoard();
var boardIsValid = board.validateBoard(gameBoard);


var memory = {};

var getRandomNotRemoved = function() {
  var value = [board.random(0, 9), board.random(0, 9)];
  if(board.removed[value[0]] && board.removed[value[0]][value[1]]) {
    return getRandomNotRemoved();
  }

  return value;
};


var success = 0;

var checkLoopMatches = function() {
  var second;
  var first = getRandomNotRemoved();
  var firstCard = board.checkCard(first[0], first[1]);

  if(memory[firstCard]) {
    if(!board.removed[first[0]] || (board.removed[first[0]] && !board.removed[first[0]][first[1]])) {
      second = memory[firstCard];
    }
  }

  if(!second) {
    second = getRandomNotRemoved();
  }

  var isMatch = board.checkMatches([first, second]);
  var secondCard = board.checkCard(second[0], second[1]);

  memory[firstCard] = first;
  memory[secondCard] = second;

  if(isMatch) {
    board.removeCard(first);
    board.removeCard(second);

    success++;
  }
};

var randomLoops = 100;
for (var i = 0; i < randomLoops; i++) {
  checkLoopMatches();
}

console.log("removed cards", board.removed);
console.log("gameBoard", gameBoard);
console.log("pairs", board.pairs);

console.log("boardIsValid", boardIsValid);

console.log("random guess success rate", ((success / randomLoops) * 100).toFixed(2));