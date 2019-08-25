require_relative 'backend'

class HTMLUI
	def initialize
		if $htmlui_qmlcontroller_instance then
			raise 'There can be only one instance of HTMLUI class.'
		end
	end
	
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
	
	def _prerender_ex
		if not $htmlui_qmlcontroller_instance then
			raise "Cannot run this method without running render(file) first."
		end
	end
	
	def [](id)
		_prerender_ex()
		if not String === id then
			raise "#{id} is not a String"
		end
		return $htmlui_qmlcontroller_instance.valueof(id)
	end
	
	def alert(msg)
		_prerender_ex()
		return $htmlui_qmlcontroller_instance.alert(msg.gsub('"', '\"'))
	end

	def prompt(msg)
		_prerender_ex()
		thread = Thread.new { $htmlui_qmlcontroller_instance.prompt(msg.gsub('"', '\"')) }
		return thread
	end
	
	def env(varn, varv)
		_prerender_ex()
		return $htmlui_qmlcontroller_instance.jsdecl(varn, varv)
	end
	
	def select_file
		_prerender_ex()
		$htmlui_qmlcontroller_instance.fd_open
	end
end
