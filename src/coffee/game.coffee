app = angular.module 'app', [
  'templates'
]

app.directive 'memorygame', ($timeout, $interval) ->
  restrict: 'E'
  templateUrl: 'memorygame.html'
  link: ($scope) ->
    $scope.rows = 2
    $scope.cardsPerRow = 4

    clickedElements = []
    lastCard = false

    $scope.gameNumber = -1
    $scope.timers = []

    stopTimer = ->
      if $scope.gameTimer
        $interval.cancel $scope.gameTimer


    getDefaultTimerObject = ->
      game: $scope.gameNumber
      time: 0
      tries: 0
      startTime: new Date()

    startTimer = ->
      $scope.gameTimer = $interval ->
        $scope.timers[$scope.gameNumber].time++
      , 1000


    $scope.reset = ->
      $scope.matches = []
      clickedElements = []
      lastCard = false
      if $scope.gameEnded
        startTimer()

      $scope.gameEnded = false
      if $scope.cards?.length
        for card in $scope.cards
          card.match = false
          card.clicked = false

    $scope.start = ->
      $scope.reset()
      stopTimer()
      $scope.gameNumber++
      $scope.timers.push getDefaultTimerObject()

      startTimer()

      options =
        boardSize: [$scope.rows, $scope.cardsPerRow]

      $scope.cards = []
      $scope.board = new Board()
      gameBoard = $scope.board.init(options)
      boardIsValid = $scope.board.validateBoard(gameBoard)

      if !boardIsValid
        console.warn 'Board is invalid :('
        return false

      $scope.board.board.forEach (row, rowIndex) ->
        row.forEach (card, cardIndex) ->

          data =
            rowIndex: rowIndex
            cardIndex: cardIndex
            number: card
            cardClass: "card-#{$scope.board.random(1, 12)}"
            clicked: false
            match: false

          $scope.cards.push data

    $scope.start()

    clearCards = ->
      clickedElements = []
      lastCard = false
      for card in $scope.cards when card.match isnt true
        card.clicked = false


    $scope.toggleCard = (card) ->
      if $scope.gameEnded or card.match
        return false

      if clickedElements.length == 2
        clearCards()

      card.clicked = !card.clicked

      $scope.timers[$scope.gameNumber].tries++

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
          if $scope.board.checkMatches [selectedCard, lastCard]
            console.log 'match!'
            setMatchCards card

        lastCard = selectedCard

      else
        clickedElements.splice clickedElements.indexOf(cardJson), 1
        lastCard = false

      console.log 'text', $scope.board.checkCard(selectedCard[0], selectedCard[1])


    setMatchCards = (matchCard) ->
      $scope.matches.push matchCard

      if $scope.matches.length is $scope.board.pairs
        stopTimer()
        $scope.timers[$scope.gameNumber].endTime = new Date()
        $scope.gameEnded = true

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
          , $scope.board.random(300, 2000)

          window.intervals.push interval
