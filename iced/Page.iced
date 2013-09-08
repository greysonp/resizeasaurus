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

    @THRESH_SQUISH: 10

    @MIDPOINT: 0

    @ROTATION_FACTOR: 10

    cleansed: false

    @SQUISH_FACTOR: 1.5

    stage: null

    NUM_WINDOWS: 7

    windows: []

    @GRAVITY: 3

    @SPEED: 50

    WIN_SIZE: 100

    constructor: (cb) ->
        console.log "starting constructor"
        html2canvas document.body, { onrendered: (canvas) ->
            console.log "finished"
            $('body').prepend(canvas)
            $(canvas).hide()
            $(canvas).addClass('squish-canvas')
            cb()
            return
        }
        chrome.runtime.onConnect.addListener (port) ->
            console.assert(port.name is "dinosaur")
            port.onMessage.addListener (win) ->
                console.log "Window ID: " + win.id

    wreck: ->
        if not @cleansed
            if $('#profile_action_remove_friend a')?
                $('.squish-canvas').nextAll().css('display', 'none')
            else
                $('.squish-canvas').nextAll().remove()
            $('canvas').show()
            @cleansed = true
        if @health is 100
            @crackScreen()
        else if @health > Page.THRESH_SQUISH
            @squish()
        else
            @explode()
        return;

    crackScreen: ->
        console.log "Cracked Screen"
        # Randomly pick between two images
        imgSrc = chrome.extension.getURL "img/pieces.png"
        $('body').prepend "<img src='#{imgSrc}' class='crack-overlay' />"
        @health -= 10

    squish: ->
        $('canvas').css("height", $('canvas').height()/Page.SQUISH_FACTOR)
        $('canvas').css "top", $(document).height()/2 - $('canvas').height()/2
        @health -= 10
        return

    explode: ->
        $('body').empty()
        $('body').append("<img src='" + chrome.extension.getURL("img/bomb1.gif") + "' class='bomb-gif' />" +
            "<div id='bomb_music' style='visibility:hidden;display:none'>
                <audio id='well_meet_again' src=" + chrome.extension.getURL("../audio/well_meet_again.mp3") +
                " controls autoplay></audio></div>")
        winSize = @WIN_SIZE
        console.log "left: " + window.screenLeft + " width: " + window.innerWidth
        for i in [1..@NUM_WINDOWS]
            chrome.runtime.sendMessage {
                "win": {
                    "props": {
                        "url": window.location.href,
                        "type": "popup",
                        "width": winSize,
                        "height": winSize,
                        "left": Math.round(window.screenLeft + window.innerWidth/2 - winSize/2),
                        "top": Math.round(window.screenTop + window.innerHeight/2 - winSize/2)
                    }
                }
            }, (response) =>
                response.x = Math.round(window.screenLeft + window.innerWidth/2 - winSize/2)
                response.y = Math.round(window.screenTop + window.innerHeight/2 - winSize/2)
                response.vx = Math.round(Math.random() * Page.SPEED - Page.SPEED/2)
                response.vy = Math.round(Math.random() * Page.SPEED/2 + Page.SPEED/4)
                @windows.push(response)
                return

        setInterval @moveWindows, 1000/30
        return

    damage: ->
        console.log @health
        if @health < 25
            return "furious"
        else if @health < 50
            return "explosion"
        else if @health < 75
            return "angry"
        else
            return "no"

    moveWindows: =>
        for win, i in @windows by -1
            win.x = win.x + win.vx
            win.y = win.y - win.vy
            win.vy -= Page.GRAVITY
            if (win.y + @WIN_SIZE >= screen.height)
                chrome.runtime.sendMessage({"removeId": win.id})
                @windows.splice(i, 1)
            else
                chrome.runtime.sendMessage({
                    "windowId": win.id,
                    "updateInfo": {
                        "left": win.x,
                        "top": win.y
                    }
                })