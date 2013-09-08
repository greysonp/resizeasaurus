class Claps
	
	# Possible states
	STATES:
		HIDDEN: 0
		CLAPPING: 1

	# width of each half (less than min width of screen so there is some white space)
	WIDTH: 100

	# Minimum width of the screen
	MIN_WIDTH: 400 

	# Number of times the users claps corresponds to the amount of respect given
	number_of_claps: 0

	WAIT_TIME: 2500

	DONE_TIME: 1000

	siteMapping: {}
	site: null

	constructor: ->
		@state = @STATES.HIDDEN # initial state should be hidden

		$('body').prepend """
							<div class='left-hand'></div>
							<div class='right-hand'></div>
						  """

		$('.left-hand').css("background-image", "url(" + chrome.extension.getURL("../img/claw_left.png") + ")")
		$('.right-hand').css("background-image", "url(" + chrome.extension.getURL("../img/claw_right.png") + ")")

		@identifySite()

		return

	clapping: (percentClapped, width) ->

		@state = @STATES.CLAPPING
		pixelOffset = 100 * percentClapped 

		$('.left-hand').css 'left', pixelOffset
		$('.right-hand').css 'right', pixelOffset

		if width is 400
			# since each hand registers a clap only count half the claps
			@number_of_claps += 0.5
			new WordArt "Clap!"
			if @site?
				@siteMapping[@site]()

		return

	reset: ->
		# Don't reset while clapping
		if @state is @STATES.HIDDEN

			$('.left-hand').css "left", -@WIDTH
			$('.right-hand').css "right", -@WIDTH
		else
			@state = @STATES.HIDDEN
			setTimeout ()=>
				@done()
				return
			, @DONE_TIME
		return

	done: ->
		setTimeout ()=>
			@submitRespect()
			return
		, @WAIT_TIME

	# Submit the amount of respect given
	submitRespect: ->
		console.log "GIVE THIS SITE SOME RESPECT " + @number_of_claps

		if @number_of_claps <= 2
			$.get(
	    		"http://resizeasaurus.herokuapp.com/RESPECT/" + encodeURIComponent(document.URL) + "/",
	    		(data) ->
	       			console.log data
			);

		else if @number_of_claps > 2 and @number_of_claps < 5
			$.get(
	    		"http://resizeasaurus.herokuapp.com/RESPECT/" + encodeURIComponent(document.URL) + "/" + "none" + "/" + "clap",
	    		(data) ->
	       			console.log data
			);
		else 
			$.get(
	    		"http://resizeasaurus.herokuapp.com/RESPECT/" + encodeURIComponent(document.URL) + "/" + "none" + "/" + "awesome clap",
	    		(data) ->
	       			console.log data
			);
		return

	identifySite: ->
		url = window.location.href
		if url.indexOf("twitter.com") >= 0 and url.indexOf("/status/") > 0
			@site = "tweet"

		console.log "Site: " + @site
		# Map functions
		@siteMapping["tweet"] = @clapTweet
		return

	clapTweet: =>
		console.log "Number of claps: " + @number_of_claps
		if @number_of_claps is 2
			Main.click $('.favorite')[0]
		else if @number_of_claps is 4
			Main.click $('.retweet')[0]
		return