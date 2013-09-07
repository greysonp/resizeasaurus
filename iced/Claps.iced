class Claps
	
	# Possible states
	STATES:
		HIDDEN: 0
		HIDING: 1
		CLAPPING: 2

	# Number of times the users claps corresponds to the amount of respect given
	number_of_claps: 0

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

		# Need to add the hands divs, maybe make them hidden at the beginning
		console.log "In the constructor"
		return


	# At the zenith of the clap
	clapping: ->
		@state = @STATES.CLAPPING
		console.log "A clap!"
		return

	# Submit the amount of respect given
	submitRespect: ->
		console.log "GIVE THIS SITE SOME RESPECT"
		return

