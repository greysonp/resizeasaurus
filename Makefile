content_script = iced iced/*.iced --join --output js/content_script.js
stylus = stylus stylus/*.styl --out css/

default: 
	$(content_script)
	$(stylus)

watch:
	$(content_script) --watch
	$(stylus) --watch
