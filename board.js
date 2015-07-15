var minimumCard = 1;
var boardSize = [10, 10];
var cards = {};
var removed = {};

var pairs = boardSize[0] * boardSize[1] / 2;

var random = function(min, max) {
  return min + Math.round(Math.random() * (max-min));
};

var validateBoard = function(board) {
  var flatten =
    board
      .reduce(function(memo, row) {
        row.forEach(function(item) {
          memo.push(item);
        });
        return memo;
      }, [])
      .sort(function(a, b) {
        return a - b;
      });

  var notFound = false;
  var notEnoughPairs = false;
  for(var i = minimumCard; i <= pairs; i++) {
    if(flatten.indexOf(i) === -1) {
      notFound = i;
    }
    if(cards[i] < 2) {
      notEnoughPairs = true;
    }
  }

  if(notEnoughPairs) {
    return false;
  }

  if(flatten.length / 2 !== pairs) {
    return false;
  }

  if(notFound) {
    return false;
  }

  return true;
};

var getFreeCard = function() {
  var card = random(minimumCard, pairs);
  if(cards[card] === 2) {
    return getFreeCard();
  }

  if(!cards[card]) {
    cards[card] = 0;
  }

  cards[card]++;

  return card;
};

var createBoard = function() {
  var board = [];
  for(var i = 0; i < boardSize[0]; i++) {
    var row = [];
    for(var u = 0; u < boardSize[1]; u++) {
      row.push(getFreeCard());
    }

    board.push(row);
  }
  return board;
};


var checkCard = function(row, card) {
  return board[row][card];
};

var checkMatches = function(data) {

  // Both selections can't be for the same card
  if(data[0][0] === data[1][0]) {
    if(data[0][1] === data[1][1]) {
      return false;
    }
  }

  var card1 = checkCard(data[0][0], data[0][1]);
  var card2 = checkCard(data[1][0], data[1][1]);

  if(card1 === null || card2 === null) {
    return false;
  }

  return card1 === card2;
};

var removeCard = function(data) {
  if(!removed[data[0]]) {
    removed[data[0]] = {};
  }
  removed[data[0]][data[1]] = board[data[0]][data[1]];

  board[data[0]][data[1]] = null;
};

var board = createBoard();
var boardIsValid = validateBoard(board);



var getRandomNotRemoved = function() {
  var value = [random(0, 9), random(0, 9)];
  if(removed[value[0]] && removed[value[0]][value[1]]) {
    return getRandomNotRemoved();
  }

  return value;
};

var success = 0;
var randomLoops = 1000;
for (var i = 0; i < randomLoops; i++) {
  var first = getRandomNotRemoved();
  var second = getRandomNotRemoved();
  var isMatch = checkMatches([first, second])
  //console.log("checkMatches for", i, isMatch);

  if(isMatch) {
    removeCard(first);
    removeCard(second);

    success++;
  }
};

console.log("random guess success rate", ((success / randomLoops) * 100).toFixed(2));
console.log("removed cards", removed);
console.log("board", board);
console.log("pairs", pairs);
console.log("boardIsValid", boardIsValid);