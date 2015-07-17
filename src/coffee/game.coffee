
createGame = ->
  boardArea = document.getElementById('board')
  originalTemplate = document.getElementsByClassName('template')[0]
  template = originalTemplate.getElementsByClassName('flip-container')[0]
  divider = document.getElementById('divider')
  clickedElements = []
  lastCard = false

  options =
    boardSize: [4, 5]

  gameBoard = board.init(options)
  boardIsValid = board.validateBoard(gameBoard)

  if !boardIsValid
    console.warn 'Board is invalid :('
    return false

  append = (element, value) ->
    newElement = element.cloneNode(true)
    boardArea.appendChild newElement
    newElement

  window.shadow = ->
    elements = document.getElementsByClassName('flip-container')
    [].forEach.call elements, (element) ->
      element.classList.toggle 'shadow'

  window.shadowparty = ->
    window.intervals = window.intervals or []
    if window.intervals.length
      window.intervals.map (interval) ->
        clearInterval interval
        return
      window.intervals = []
    else
      elements = document.getElementsByClassName('flip-container')
      [].forEach.call elements, (element) ->
        interval = setInterval ->
          element.classList.toggle 'shadow'
        , board.random(300, 2000)

        window.intervals.push interval

  clearCards = ->
    elements = document.getElementsByClassName('flip-container')
    [].forEach.call elements, (element) ->
      if element.classList.contains('match')
        return false

      element.classList.remove 'clicked'

    clickedElements = []

  setMatchCards = ->
    elements = document.getElementsByClassName('clicked')
    [].forEach.call elements, (element) ->
      # poor mans transitionend right here
      setTimeout ->
        element.classList.add 'match'
        setTimeout ->
          clearCards()
      , 600

  cardClicked = ->
    # TODO: if transition in progress, wait until transition has been finished


    if clickedElements.length == 2
      clearCards()

    if @classList.contains('match')
      return false

    @classList.toggle 'clicked'
    isClicked = @classList.contains('clicked')
    selectedCard = [
      @dataset.row
      @dataset.card
    ]

    # TODO: refactor, too drunk now
    if JSON.stringify(lastCard) is JSON.stringify(selectedCard)
      clearCards()

    if lastCard and isClicked
      if board.checkMatches [selectedCard, lastCard]
        console.log 'match!'
        setMatchCards()

    cardJson = JSON.stringify(selectedCard)

    if isClicked
      clickedElements.push cardJson
      lastCard = selectedCard
    else
      clickedElements.splice clickedElements.indexOf(cardJson), 1
      lastCard = false

    console.log 'text', board.checkCard(selectedCard[0], selectedCard[1])


  appendCard = (row, card) ->
    element = append(template)
    element.dataset.row = row
    element.dataset.card = card
    element.classList.add 'card-' + board.random(1, 12)
    element.addEventListener 'click', cardClicked
    backElement = element.getElementsByClassName('back')[0]
    backElement.innerText = board.checkCard(row, card)

  for row in [0..board.options.boardSize[0] - 1]
    for card in [0..board.options.boardSize[1] - 1]
      appendCard row, card

    append divider

  # remove original template
  document.body.removeChild originalTemplate


document.addEventListener 'DOMContentLoaded', ->
  createGame()

