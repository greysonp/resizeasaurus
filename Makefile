cs = iced iced/*.iced --join --output js/content_script.js

default: 
	$(cs)

watch:
	$(cs) --watch
