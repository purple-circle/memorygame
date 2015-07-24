app = angular.module 'app', [
  'templates'
  'imgurUpload'
]

app.service 'api', ->
  preloadImage: (url) ->
    img = new Image()
    img.src = url

  getImgurIds: ->
    [
      'MKP7m'
      'imG3t'
      'vtQ3QPm'
      'Cxfr0m9'
      'NhRGsb8'
      'HIMT9Fe'
      '96gq9FD'
      '7so0762'
      'lxi6HUO'
      '0dqdq3m'
      'ZNGRKgg'
      'wzOhnr1'
      '2nnhlSX'
      'dFTWZ2O'
      '8YklGKx'
      'eAAJ0ke'
      'mIpaptU'
      'ldlNrB3'
      'D40aExi'
      'u8Gs0Gl'
      'qPPIL0h'
      'MGQwkGC'
      'Mt8AJYn'
      'fntodFQ'
      '2wwY8jo'
      'jkccDfu'
      'OoJzecx'
      'FG8nz3P'
      'jsHKrF3'
      'vuelbHR'
      'Eo2obrh'
      'OCoo4jE'
      'shTqv5n'
      '8hlWZtl'
      'GeYMhoh'
      'vWWHaWr'
      'c6uGFzT'
      'nBiT78L'
      'IOqBM8T'
      'q0C7BKR'
      '1g3nT4K'
      '3L05a1D'
      'RP0X5F0'
    ]

  getImgurUrlFromId: (id) ->
    "http://i.imgur.com/#{id}.jpg"

  # TODO: implement something from lodash etc
  shuffle: (array) ->
    counter = array.length
    # While there are elements in the array
    while counter > 0
      # Pick a random index
      index = Math.floor(Math.random() * counter)
      # Decrease counter by 1
      counter--
      # And swap the last element with it
      temp = array[counter]
      array[counter] = array[index]
      array[index] = temp
    array


app.directive 'memorygame', ($timeout, $interval, $window, api, imgurUpload) ->
  restrict: 'E'
  templateUrl: 'memorygame.html'
  link: ($scope) ->
    $scope.rows = 4
    $scope.cardsPerRow = 6

    clickedElements = []
    lastCard = false

    $scope.gameNumber = -1
    $scope.timers = []

    $scope.showNumber = false

    # TODO: move to app.config
    imgurUpload.setClientId "c3adff5c1adb461"

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

    calculateCardWidth = ->
      $scope.cardWidth = Math.floor(($window.innerWidth * 0.7) / $scope.cardsPerRow)


    angular.element($window).bind "resize", calculateCardWidth

    calculateCardWidth()

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

      $scope.images = api.shuffle(api.getImgurIds())[0..$scope.board.pairs-1]

      for id in $scope.images
        api.preloadImage api.getImgurUrlFromId id

      if !boardIsValid
        console.warn 'Board is invalid :('
        return false

      $scope.board.board.forEach (row, rowIndex) ->
        row.forEach (card, cardIndex) ->

          data =
            image: api.getImgurUrlFromId $scope.images[card-1]
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

      if clickedElements.length is 2
        clearCards()

      card.clicked = !card.clicked

      $scope.timers[$scope.gameNumber].tries++

      selectedCard = [
        card.rowIndex
        card.cardIndex
      ]

      cardJson = JSON.stringify(selectedCard)

      if angular.equals lastCard, selectedCard
        return clearCards()

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
        card.matchTime = new Date()

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


    $scope.selectFile = ->
      document.getElementById("image-upload").click()

    hideProgressBarTimeout = null

    hideProgressBar = ->
      if hideProgressBarTimeout
        $timeout.cancel(hideProgressBarTimeout)

      hideProgressBarTimeout = $timeout ->
        $scope.showProgress = false
      , 1000

    $scope.uploadFile = (element) ->
      if !element?.files?[0]?
        return

      #ga('send', 'event', 'uploaded image')

      upload_success = (result) ->
        console.log "result", result
        angular.element(element).val(null)
        hideProgressBar()

        link = result?.data?.link

        console.log "link", link

      upload_error = (err) ->
        console.log "err", err
        #ga('send', 'event', 'image upload error', JSON.stringify(err))
        hideProgressBar()

      upload_notify = (progress) ->
        $timeout ->
          $scope.uploadProgress = progress

      $scope.showProgress = true
      $scope.uploadProgress = 0

      imgurUpload
        .upload(element.files[0])
        .then upload_success, upload_error, upload_notify
