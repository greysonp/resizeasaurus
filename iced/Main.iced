class Main

    # Statics
    @MIN_WIDTH: 400
    @MIN_HEIGHT: 200
    @PEEK_THRESHOLD: 300
    @CLAP_THRESHOLD: 650
        
    @page: null

    constructor: ->
        Main.page = new Page () =>
            @jaws = new Jaws
            @claps = new Claps
            return
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
            @jaws.tween percentClosed
        else
            @jaws.reset()

        return

    resizeWidth: (width) ->
        # check width
        if width < Main.CLAP_THRESHOLD
            pixelsToClose = width - Main.MIN_WIDTH
            percentClosed = 1 - (pixelsToClose/(Main.CLAP_THRESHOLD - Main.MIN_WIDTH))
            @claps.clapping percentClosed, width
        else
            @claps.reset()
        return

    @click: (element) ->
        if element.fireEvent? 
            element.fireEvent('onclick')
        else
            evObj = document.createEvent 'Events'
            evObj.initEvent 'click', true, false
            element.dispatchEvent evObj

main = new Main