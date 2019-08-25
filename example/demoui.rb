require 'htmlui'

$ui = HTMLUI.new

def sayhello
	$ui.alert("Hello there, #{ENV['USER'].capitalize || 'user'}!")
end

$ui.render('demoui.html')
