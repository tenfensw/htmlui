require_relative 'backend'

# HTMLUI main class
class HTMLUI
	# Creates a new instance of HTMLUI. Notice that only one instance of HTMLUI can be created.
	def initialize
		if $htmlui_qmlcontroller_instance then
			raise 'There can be only one instance of HTMLUI class.'
		end
	end
	
	# Renders the HTML from ``file``.
	#
	# @param file [String] Full path to the HTML file to render.
	def render(file)
		if not File.exists? file then
			raise "#{file} - no such file or directory."
		end
		$htmlui_qmlcontroller_ui = File.read(file)
		if not $htmlui_qmlcontroller_instance then
			start_htmlui_browser
		else
			$htmlui_qmlcontroller_instance.render
		end
	end
	
	# @!visibility private
	def _prerender_ex
		if not $htmlui_qmlcontroller_instance then
			raise "Cannot run this method without running render(file) first."
		end
	end
	
	# Finds an element on the rendered HTML page and returns its text value. Returns nil if there is no element with ID ``id``.
	#
	# @param id [String] The ID to look for. The ID should be specified in the HTML page itself.
	# @return [String] The stringified value of the element.
	def [](id)
		_prerender_ex()
		if not String === id then
			raise "#{id} is not a String"
		end
		return $htmlui_qmlcontroller_instance.valueof(id)
	end
	
	# Creates an alert. Works the same as JavaScript alert function. Notice that this function is async.
	#
	# @param msg [String] The inner text of the alert.
	# @return [TrueClass] ``true`` on success, ``false`` on fail.
	def alert(msg)
		_prerender_ex()
		return $htmlui_qmlcontroller_instance.alert(msg.gsub('"', '\"'))
	end

	# @!visibility private
	def prompt(msg)
		_prerender_ex()
		thread = Thread.new { $htmlui_qmlcontroller_instance.prompt(msg.gsub('"', '\"')) }
		return thread
	end
	
	# Creates a new JavaScript variable ``varn`` and sets its value to ``varv``.
	#
	# @param varn [String] The name of the variable.
	# @param varv [Object] The value of the variable. The type of this argument can only be either a String, a Hash, an Array or an Integer.
	# @return [TrueClass] ``true`` on success, ``false`` on fail
	def env(varn, varv)
		_prerender_ex()
		return $htmlui_qmlcontroller_instance.jsdecl(varn, varv)
	end
	
	# Shows the file picker dialog. While nothing is returned when the dialog closes, a new hidden HTML element 
	# called ``selected_file`` is created the value of which will be either an empty string or the stringified
	# full path to the file selected by the user.
	def select_file
		_prerender_ex()
		$htmlui_qmlcontroller_instance.fd_open
	end
end
