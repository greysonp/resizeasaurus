class Jaws
    # The possible states the monster can have
    STATES:  
        HIDING: 1 
        HIDDEN: 2
        PEEKING: 3
        CHOMPING: 4

    # The height of each half
    HEIGHT: 100

    # How long to peek for before going back to hiding
    PEEK_TIME: 1000

    # How long it takes to transition out between states
    TRANSITION_TIME: 500

    # How long before we exit 'couldChomp' mode (in ms)
    CHOMP_COOLDOWN: 1000

    # How long before we consider the user to be done chomping
    DONE_COOLDOWN: 2500

    # What percentage of the teeth we always want to be visible
    # in the CHOMPING state
    TEETH_PERCENT: .3

    # Whether or not we are fully closed
    closed: false

    # Whether we could potentially chomp
    couldChomp: false

    # The timer id of our done timer (kept so we can cancel it)
    doneTimer: null

    constructor: ->
        @state = @STATES.HIDDEN

        # Add our divs to the page.
        # We need to stretch it appropriately, so we have static end pieces
        # and a stretchable middle piece.
        $('body').prepend """
                            <div id="monster-t"></div>
                            <div id="monster-b"></div>
                          """

        # We can't do @sizeJaws because the first set is different
        if $(window).width() > 800
            $('#monster-t').css("background-image", "url(" + chrome.extension.getURL("../img/jaws_top_1200.png") + ")")
            $('#monster-b').css("background-image", "url(" + chrome.extension.getURL("../img/jaws_bottom_1200.png") + ")")
        else 
            $('#monster-t').css("background-image", "url(" + chrome.extension.getURL("../img/jaws_top_800.png") + ")")
            $('#monster-b').css("background-image", "url(" + chrome.extension.getURL("../img/jaws_bottom_800.png") + ")")

    # Chooses the right positioning function based on the state
    tween: (percentClosed) ->
        @sizeJaws()
        if @state is @STATES.CHOMPING
            @chompTween percentClosed
        else if @state isnt @STATES.HIDING
            @peek percentClosed
        return

    # Peeks out both halves of the monster. 
    # We put it in the PEEKING state right away.
    peek: (percentClosed) ->
        pixelOffset = percentClosed * @HEIGHT - @HEIGHT
        @state = @STATES.PEEKING
        $('#monster-t').css 'top', pixelOffset
        $('#monster-b').css 'bottom', pixelOffset

        # If we've fully closed, mark it as such and check
        # if we just chomped
        if percentClosed is 1
            @closed = true
            if @couldChomp
                @chomp()
                @couldChomp = false
        else if @closed
            @closed = false
            @couldChomp = true
            @startChompTimer()

        return

    # Similar to peek, but we never fully retract the teeth
    chompTween: (percentClosed) ->
        adjustedHeight = @HEIGHT * (1 - @TEETH_PERCENT)
        pixelOffset = percentClosed * adjustedHeight - adjustedHeight
        pixelOffset = if pixelOffset > 0 then 0 else pixelOffset
        $('#monster-t').css 'top', pixelOffset
        $('#monster-b').css 'bottom', pixelOffset

        if percentClosed is 1
            @closed = true
            if @couldChomp
                @chomp()
                @couldChomp = false
                @startDoneTimer()
        else if @closed
            @closed = false
            @couldChomp = true

        return

    # Chomps down and does some damage
    chomp: ->
        @state = @STATES.CHOMPING
        @resetDoneTimer()
        Main.page.wreck()
        console.log "CHOMP"
        return

    # Hides both the top and bottom halves of the monster.
    # We wait until the hiding is done before changing the state to HIDING.
    hide: ->
        @state = @STATES.HIDING
        @couldChomp = false
        @closed = false

        @hideHalf '#monster-t', 'top'
        @hideHalf '#monster-b', 'bottom'

        # This timer will finish at the same time the
        # halves are done hiding
        setTimeout () =>
            @state = @STATES.HIDDEN
            @submitWreckage()
            return
        , @TRANSITION_TIME

        return

    hideHalf: (selector, property) ->
        props = {}
        props[property] = -@HEIGHT
        $(selector).animate props, @TRANSITION_TIME
        return

    # Resets the jaws positions back to their starting state with
    # no animation.
    reset: ->
        # If we're chomping, we don't want to reset. We want to 
        # hide if inactive
        if @state isnt @STATES.CHOMPING
            @state = @STATES.HIDDEN
            $('#monster-t').css 'top', -@HEIGHT
            $('#monster-b').css 'bottom', -@HEIGHT
        return

    # Starts off our chomp timer which will get us out of chomp mode if we 
    # don't chomp within a certain time frame after closing
    startChompTimer: ->
        setTimeout ()=>
            @couldChomp = false
            return
        , @CHOMP_COOLDOWN
        return

    startDoneTimer: ->
        # Don't start it if we already have one going
        if @doneTimer?
            return

        @doneTimer = setTimeout ()=>
            @hide()
            return
        , @DONE_COOLDOWN
        return

    resetDoneTimer: ->
        if @doneTimer?
            clearTimeout(@doneTimer)
            @doneTimer = null
            @startDoneTimer()


    # Submits our wreckage to the server to be tweeted
    submitWreckage: =>
        console.log "THIS SITE GOT WRECKED"

        $.get(
                "http://resizeasaurus.herokuapp.com/WRECK/" + encodeURIComponent(document.URL) + "/" + "none" + "/" + Main.page.damage(),
                (data) ->
                    console.log data
            );

        return

    sizeJaws: ->
        currImg = $('#monster-t').css("background-image");
        currSize = "1200"
        console.log currImg
        console.log "IndexOf: " + currImg.indexOf "800"
        if currImg.indexOf("800") >= 0
            currSize = "800"

        console.log "currSize: " + currSize

        if $(window).width() > 800 and currSize isnt "1200"
            $('#monster-t').css("background-image", "url(" + chrome.extension.getURL("../img/jaws_top_1200.png") + ")")
            $('#monster-b').css("background-image", "url(" + chrome.extension.getURL("../img/jaws_bottom_1200.png") + ")")
        if $(window).width() <= 800 and currSize isnt "800"
            $('#monster-t').css("background-image", "url(" + chrome.extension.getURL("../img/jaws_top_800.png") + ")")
            $('#monster-b').css("background-image", "url(" + chrome.extension.getURL("../img/jaws_bottom_800.png") + ")")
