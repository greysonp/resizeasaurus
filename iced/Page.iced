class Page
    # How much health the page has. We can use this to determine what
    # kind of wreckage the page will experience
    health: 100

    # A list of all of the elements we'll be wrecking.
    # We'll try to grab the leaves of the DOM tree so we have the
    # most individual pieces.
    elements: []

    # An array of rotation values that matches up with @elements
    rotations: []

    @THRESH_SQUISH: 50

    @MIDPOINT: 0

    @ROTATION_FACTOR: 10

    cleansed: false

    @SQUISH_FACTOR: 1.3

    stage: null

    @NUM_ROWS: 5
    @NUM_COLS: 8

    constructor: (cb) ->
        console.log "starting constructor"
        html2canvas document.body, { "onrendered": (canvas) ->
            console.log "finished"
            $('body').prepend(canvas)
            $(canvas).hide()
            $(canvas).addClass('squish-canvas')
            cb()
            return
        }

    wreck: ->
        if not @cleansed
            $('.squish-canvas').nextAll().remove()
            $('canvas').show()
            @cleansed = true
        if @health > Page.THRESH_SQUISH
            @squish()
        else
            @explode()
        return;

    squish: ->
        $('canvas').css("height", $('canvas').height()/Page.SQUISH_FACTOR)
        $('canvas').css "top", $(document).height()/2 - $('canvas').height()/2
        @health -= 10
        return

    explode: ->
        return


