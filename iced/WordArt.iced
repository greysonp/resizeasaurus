class WordArt

    constructor: (text) ->
        @text = text
        @x = Math.random() * $(window).width()
        @y = Math.random() * $(window).height()

        $('body').append "<span class='word-art' style='top:#{@x}px; left:#{@y}px;'>#{@text}</span>"
        $('.word-art').fadeOut 2000, ()->
            $(this).remove()


