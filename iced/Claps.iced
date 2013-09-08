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

	sound_player: true

	applause: ""

	constructor: ->
		@state = @STATES.HIDDEN # initial state should be hidden

		$('body').prepend """

			<div class='left-hand'>
			</div>
			<div class='right-hand'>
			</div>	
		"""
		clap_list = [chrome.extension.getURL('../audio/clap_1.mp3'), chrome.extension.getURL('../audio/clap_2.mp3'), chrome.extension.getURL('../audio/clap_3.mp3')]
		@applause = chrome.extension.getURL('../audio/strong_applause.mp3')

		$('body').append "<div id='music_player' style='visibility:hidden;display:none;'>
				<audio id='audio_player_1' src=" + clap_list[0]  + " ></audio>
				<audio id='audio_player_2' src=" + clap_list[1]  + " ></audio>
				<audio id='audio_player_3' src=" + clap_list[2]  + " ></audio>
			</div>"

		return

	clapping: (percentClapped, width) ->

		@state = @STATES.CLAPPING
		pixelOffset = 100 * percentClapped 

		$('.left-hand').css 'left', pixelOffset
		$('.right-hand').css 'right', pixelOffset

		if width is 400
			# since each hand registers a clap only count half the claps
			@number_of_claps += 0.5
			random_clap = "#audio_player_" + Math.floor(Math.random() * 3 + 1)
			console.log random_clap + "<--- which audio id"
			$(random_clap)[0].play()

			console.log @sound_player
			if @sound_player is true
				console.log "Should be putting applause in"
				@sound_player = !true
				$('body').append "<div id='applause_player' style='visibility:hidden;display:none'> 
						<audio id='background_applause' src=" + @applause + " controls autoplay loop></audio>
					</div>"
				
		return

	reset: ->
		# Don't reset while clapping
		if @state is @STATES.HIDDEN

			$('.left-hand').css "left", -@WIDTH
			$('.right-hand').css "right", -@WIDTH
		else
			@state = @STATES.HIDDEN
			$('div').remove("#applause_player")
			@sound_player = true
			setTimeout ()=>
				@done()
				return
			, @DONE_TIME
		return

	done: ->
		setTimeout ()=>
			$('div').remove '#soundcloud_player'
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

