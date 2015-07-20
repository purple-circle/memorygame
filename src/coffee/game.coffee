app = angular.module 'app', [
  'templates'
]

app.directive 'memorygame', ($timeout) ->
  restrict: 'E'
  templateUrl: 'memorygame.html'
  link: ($scope) ->
    $scope.rows = 4
    $scope.cardsPerRow = 5
    $scope.matches = []

    clickedElements = []
    lastCard = false

    options =
      boardSize: [$scope.rows, $scope.cardsPerRow]

    board = new Board()
    gameBoard = board.init(options)
    boardIsValid = board.validateBoard(gameBoard)

    if !boardIsValid
      console.warn 'Board is invalid :('
      return false

    $scope.cards = []
    board.board.forEach (row, rowIndex) ->
      row.forEach (card, cardIndex) ->

        data =
          rowIndex: rowIndex
          cardIndex: cardIndex
          number: card
          cardClass: "card-#{board.random(1, 12)}"
          clicked: false
          match: false

        $scope.cards.push data


    clearCards = ->
      clickedElements = []
      lastCard = false
      for card in $scope.cards when card.match isnt true
        card.clicked = false


    $scope.toggleCard = (card) ->
      if card.match
        return false

      if clickedElements.length == 2
        clearCards()

      card.clicked = !card.clicked

      selectedCard = [
        card.rowIndex
        card.cardIndex
      ]

      cardJson = JSON.stringify(selectedCard)

      # TODO: refactor, too drunk now
      if JSON.stringify(lastCard) is cardJson
        clearCards()

      if card.clicked
        clickedElements.push cardJson

        if clickedElements.length is 2
          if board.checkMatches [selectedCard, lastCard]
            console.log 'match!'
            setMatchCards card

        lastCard = selectedCard

      else
        clickedElements.splice clickedElements.indexOf(cardJson), 1
        lastCard = false

      console.log 'text', board.checkCard(selectedCard[0], selectedCard[1])


    setMatchCards = (matchCard) ->
      $scope.matches.push matchCard

      for card in $scope.cards when card.number is matchCard.number
        card.match = true

      $timeout ->
        clearCards()
      , 600


    window.shadow = ->
      elements = document.getElementsByClassName('flip-container')
      [].forEach.call elements, (element) ->
        element.classList.toggle 'shadow'


    window.shadowparty = ->
      window.intervals ?= []
      if window.intervals.length
        window.intervals.map (interval) ->
          clearInterval interval

        window.intervals = []
      else
        elements = document.getElementsByClassName('flip-container')
        [].forEach.call elements, (element) ->
          interval = setInterval ->
            element.classList.toggle 'shadow'
          , board.random(300, 2000)

          window.intervals.push interval
