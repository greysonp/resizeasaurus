content_script = --join js/content_script.js --compile iced/Jaws.iced iced/Claps.iced iced/Page.iced iced/WordArt.iced iced/Main.iced  

stylus = stylus stylus/*.styl --out css/

default: 
	iced $(content_script)
	$(stylus)

watch:
	iced --watch $(content_script)
	$(stylus) --watch
