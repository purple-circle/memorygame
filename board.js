var minimumCard = 1;
var boardSize = [10, 10];
var cards = {};

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
  return checkCard(data[0][0], data[0][1]) === checkCard(data[1][0], data[1][1]);
}

var board = createBoard();
var boardIsValid = validateBoard(board);


console.log("pairs", pairs);
console.log("boardIsValid", boardIsValid);
console.log("board", board);


console.log("checkCard", checkCard(0, 5));


console.log("checkMatches", checkMatches([[0,5], [4,5]]));


