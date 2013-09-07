class Jaws
    # The possible states the monster can have
    STATES:   
        HIDDEN: 1
        PEEKING: 2
        CHOMPING: 3

    # The height of each half
    HEIGHT: 100

    # How long to peek for before going back to hiding
    PEEK_TIME: 1000

    # How long it takes to transition out between states
    TRANSITION_TIME: 500

    constructor: ->
        @state = @STATES.HIDDEN

        # Add our divs to the page.
        # We need to stretch it appropriately, so we have static end pieces
        # and a stretchable middle piece.
        $('body').prepend("""
                            <div id="monster-t">
                                <div class="monster-l"></div>
                                <div class="monster-m"></div>
                                <div class="monster-r"></div>
                            </div>
                            <div id="monster-b">
                                <div class="monster-l"></div>
                                <div class="monster-m"></div>
                                <div class="monster-r"></div>
                            </div>
                          """)

    # Peeks out both halves of the monster. 
    # We put it in the PEEKING state right away.
    peek: (percentClosed) ->
        pixelOffset = percentClosed * @HEIGHT - @HEIGHT
        @state = @STATES.PEEKING
        $('#monster-t').css 'top', pixelOffset
        $('#monster-b').css 'bottom', pixelOffset
        return

    # Hides both the top and bottom halves of the monster.
    # We wait until the hiding is done before changing the state to HIDING.
    hide: ->
        @hideHalf '#monster-t', 'top'
        @hideHalf '#monster-b', 'bottom'
        return

    hideHalf: (selector, property)->
        props = {}
        props[property] = -@HEIGHT
        $(selector).animate props, @TRANSITION_TIME, ()=>
            @state = @STATES.HIDDEN
            return
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
