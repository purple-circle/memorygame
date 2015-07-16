(function(document) {
  var createGame = function() {
    var boardArea = document.getElementById("board");
    var originalTemplate = document.getElementsByClassName("template")[0];
    var template = originalTemplate.getElementsByClassName("flip-container")[0];
    var divider = document.getElementById("divider");

    var options = {
      boardSize: [4, 5]
    };

    var gameBoard = board.init(options);
    var boardIsValid = board.validateBoard(gameBoard);

    if(!boardIsValid) {
      console.warn("Board is invalid :(");
      return false;
    }

    var append = function(element, value) {
      var newElement = element.cloneNode(true);
      boardArea.appendChild(newElement);
      return newElement;
    };

    window.shadow = function() {
      [].forEach.call(document.getElementsByClassName("flip-container"), function(element) {
        element.classList.toggle("shadow");
      });
    };

    window.shadowparty = function() {
      window.intervals = window.intervals || [];
      if(window.intervals.length) {
        window.intervals.map(function(interval) {
          clearInterval(interval);
        });
        window.intervals = [];
      } else {
        [].forEach.call(document.getElementsByClassName("flip-container"), function(element) {
          var interval = setInterval(function() {
            element.classList.toggle("shadow");
          }, board.random(300, 2000));
          window.intervals.push(interval);
        });
      }
    };

    var lastCard = false;
    var cardClicked = function() {
      this.classList.toggle("clicked");

      var isClicked = this.classList.contains("clicked");
      var selectedCard = [this.dataset.row, this.dataset.card];

      if(lastCard && isClicked) {
        if(board.checkMatches([selectedCard, lastCard])) {
          console.log("match!");
        }
      }

      if(isClicked) {
        lastCard = selectedCard;
      } else {
        lastCard = false;
      }

      console.log("text", board.checkCard(selectedCard[0], selectedCard[1]));
    };

    var appendCard = function(row, card) {
      var element = append(template);
      element.dataset.row = row;
      element.dataset.card = card;

      element.classList.add("card-" + board.random(1, 12));
      element.addEventListener("click", cardClicked);
      element.getElementsByClassName("back")[0].innerText = board.checkCard(row, card);
    };

    for (var row = board.options.boardSize[0] - 1; row >= 0; row--) {
      for (var card = board.options.boardSize[1] - 1; card >= 0; card--) {
        appendCard(row, card);
      }
      append(divider);
    }

    // remove original template
    document.body.removeChild(originalTemplate);
  };

  document.addEventListener("DOMContentLoaded", function() {
    createGame();
  });

})(document);