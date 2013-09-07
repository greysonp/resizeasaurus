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

	constructor: ->
		@state = @STATES.HIDDEN # initial state should be hidden

		$('body').prepend """
				<div class='left-hand'>
					<h1> A BIG LEFT HAND </h1>
				</div>
				<div class='right-hand'>
					<h1> A BIG RIGHT HAND </h1>
				</div>
			"""
		return

	clapping: (percentClapped, width) ->

		@state = @STATES.CLAPPING
		pixelOffset = 100 * percentClapped 

		$('.left-hand').css 'left', pixelOffset
		$('.right-hand').css 'right', pixelOffset

		if width is 400
			# since each hand registers a clap only count half the claps
			@number_of_claps += 0.5

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
		return

