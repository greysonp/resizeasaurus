class Main

    # Statics
    @MIN_WIDTH: 400
    @MIN_HEIGHT: 200
    @PEEK_THRESHOLD: 300

    constructor: ->
        @jaws = new Jaws
        $(window).resize @onResize

    onResize: =>
        @resizeHeight $(window).height()
        @resizeWidth $(window).width()
        return

    resizeHeight: (height)->
        # Check height
        if height < Main.PEEK_THRESHOLD
            pixelsToClose = height - Main.MIN_HEIGHT
            percentClosed = 1 - (pixelsToClose/(Main.PEEK_THRESHOLD - Main.MIN_HEIGHT))
            @jaws.peek percentClosed
        else
            @jaws.reset()

        return

    resizeWidth: (width) ->
        return

main = new Main