var board = {
  options: {
    minimumCard: 1,
    boardSize: [10, 10],
  },
  cards: {},
  removed: {},
  pairs: 0,
  board: [],
  inited: false,
  init: function(options) {
    if(options) {
      this.options = this.extend(this.options, options);
    }

    this.inited = true;
    this.calculatePairs();

    if(this.pairs % 2) {
      console.log("Not enough pairs to go around");
      return false;
    }

    return this.createBoard();
  },
  createBoard: function() {
    if(!this.inited) {
      console.log("Run init");
      return false;
    }

    this.board = [];
    for(var i = 0; i < this.options.boardSize[0]; i++) {
      var row = [];
      for(var u = 0; u < this.options.boardSize[1]; u++) {
        row.push(this.getFreeCard());
      }

      this.board.push(row);
    }
    return this.board;
  },
  calculatePairs: function() {
    this.pairs = this.options.boardSize[0] * this.options.boardSize[1] / 2;
  },
  random: function(min, max) {
    return min + Math.round(Math.random() * (max-min));
  },
  validateBoard: function(board) {
    if(!this.pairs) {
      return false;
    }

    var flatten =
      this.board
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
    for(var i = this.options.minimumCard; i <= this.pairs; i++) {
      if(flatten.indexOf(i) === -1) {
        notFound = i;
      }
      if(this.cards[i] < 2) {
        notEnoughPairs = true;
      }
    }

    if(notEnoughPairs) {
      return false;
    }

    if(flatten.length / 2 !== this.pairs) {
      return false;
    }

    if(notFound) {
      return false;
    }

    return true;
  },
  getFreeCard: function() {
    var card = this.random(this.options.minimumCard, this.pairs);

    if(this.cards[card] === 2) {
      return this.getFreeCard();
    }

    if(!this.cards[card]) {
      this.cards[card] = 0;
    }

    this.cards[card]++;

    return card;
  },
  checkCard: function(row, card) {
    return this.board[row][card];
  },
  checkMatches: function(data) {

    // Both selections can't be for the same card
    if(data[0][0] === data[1][0]) {
      if(data[0][1] === data[1][1]) {
        return false;
      }
    }

    var card1 = this.checkCard(data[0][0], data[0][1]);
    var card2 = this.checkCard(data[1][0], data[1][1]);

    if(card1 === null || card2 === null) {
      return false;
    }

    return card1 === card2;
  },
  removeCard: function(data) {
    if(!this.removed[data[0]]) {
      this.removed[data[0]] = {};
    }
    this.removed[data[0]][data[1]] = this.board[data[0]][data[1]];

    this.board[data[0]][data[1]] = null;
  },
  extend: function() {
    var extended = {};

    for(key in arguments) {
      var argument = arguments[key];
      for (prop in argument) {
        if (Object.prototype.hasOwnProperty.call(argument, prop)) {
          extended[prop] = argument[prop];
        }
      }
    }

    return extended;
  }
};

if(typeof module !== "undefined") {
  module.exports = board;
}
