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
        if not @stage?
            @initStage()
        else
            @pulse()
        return

    initStage: ->
        console.log "initStage()"
        @stage = new createjs.Stage($('canvas')[0])

        # Get our scaled data url
        dataUrl = Canvas2Image.saveAsPNG $('canvas')[0], false, $(window).width(), $('canvas').height()
        $('body').append "<img id='data-img' src='#{dataUrl}' />" 
        bitmap = new createjs.Bitmap document.getElementById('data-img')
        bitmap.x = 200
        bitmap.y = 200
        bitmap.width = 200
        @stage.addChild bitmap
        createjs.Ticker.addEventListener "tick", () =>
            @stage.update()
            console.log "Updated"
        # Init our spritesheet
        # var data = {
        # data = 
        #     images: [dataUrl]
        #     frames: {width:$(window).width()/Page.NUM_COLS, height:$('canvas').height()/Page.NUM_ROWS}

        # spriteSheet = new createjs.SpriteSheet data
        # animation = new createjs.Bitmap dataUrl
        # # animation.gotoAndStop 1
        # @stage.addChild animation
        # @stage.update()
        return

    pulse: ->
        console.log "pulse()"
        return

    damage: ->
        console.log @health
        if @health < 25
            return "explode"
        else if @health < 50
            return "explode"
        else if @health < 75
            return "explode"
        else
            return "explosion"

