require 'qml'

$htmlui_qmlcontroller_instance = nil
$htmlui_qmlcontroller_ui = ''

module HTMLUILogic
	module HTMLUIController
		VERSION = '1.0'
		
		class HTMLUIController
			include QML::Access
			register_to_qml
			
			property(:content) { 'http://example.com' }
			property(:windowConnected) { 0 }
			
			def render
				@locked = false
				if not @wvref then
					return
				end
				@wvref.method_missing(:loadHtml, $htmlui_qmlcontroller_ui)
			end
			
			def decide(url, wvref)
				if not $htmlui_qmlcontroller_instance then
					$htmlui_qmlcontroller_instance = self
				end
				if @locked then
					@locked = false
					return
				end
				@wvref = wvref
				if url.downcase.start_with? 'rb:' then
					torun = url[3...url.length]
					eval(torun)
				else
					@wvref.method_missing(:loadHtml, $htmlui_qmlcontroller_ui)
				end
				@locked = true
			end
			
			def valueof(id)
				if not @wvref then
					return nil
				end
				result = @wvref.method_missing(:runJavaScript, 'document.getElementById(\'' + id.to_s.gsub('\'', "\\'") + '\').value')
				#result = result.method_missing(:toString)
				return result
			end
			
			def alert(string)
				if not @wvref then
					return false
				end
				@wvref.method_missing(:runJavaScript, "alert(\"#{string}\")")
			end
			
			def jsquit
				puts "Application terminated as specified in JavaScript."
				QML.application.quit
			end
		end
	end
end

def start_htmlui_browser
	QML.run do |app| 
		app.load_path File.absolute_path(File.dirname(__FILE__)) + '/minibrowser.qml'
	end
end
