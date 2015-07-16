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

    var append = function(element, value) {
      var newElement = element.cloneNode(true);
      boardArea.appendChild(newElement);
      return newElement;
    };

    var appendCard = function(value) {
      var element = append(template);
      element.classList.add("card-" + board.random(1, 6));
      element.addEventListener("click", function() {
        this.classList.toggle("clicked");
      });
      element.getElementsByClassName("back")[0].innerHTML = value;
    };

    for (var i = board.options.boardSize[0] - 1; i >= 0; i--) {
      for (var u = board.options.boardSize[1] - 1; u >= 0; u--) {
        appendCard(board.board[i][u]);
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