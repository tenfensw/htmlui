require 'qml'
require 'json'

$htmlui_qmlcontroller_instance = nil
$htmlui_qmlcontroller_ui = ''

# @!visibility private
module HTMLUILogic
	module HTMLUIController
		VERSION = '1.0'
		
		class HTMLUIController
			include QML::Access
			register_to_qml
			
			property(:content) { 'http://example.com' }
			property(:windowConnected) { 0 }
			property(:fdialogFileName) { '' }
			signal :openFileDialog, []
			
			def fd_open
				openFileDialog.emit
			end
			
			on_changed :fdialogFileName do
				@objects_wp['selected_file'] = fdialogFileName.clone
			end
			
			def render
				@locked = false
				if not @wvref then
					return
				end
				@objects_wp = {}
				@wvref.method_missing(:loadHtml, $htmlui_qmlcontroller_ui)
			end
			
			def decide(url, wvref)
				if not $htmlui_qmlcontroller_instance then
					$htmlui_qmlcontroller_instance = self
				end
				if url.downcase.start_with? 'rb:' then
					@locked = false
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
			
			def cache_objects(arg)
				@objects_wp = arg.to_hash
				@objects_wp['selected_file'] = fdialogFileName.clone
			end
			
			def valueof(id)
				if not (@wvref && @objects_wp.keys.include?(id)) then
					return nil
				end
				return @objects_wp[id].to_s
			end
			
			def qmlputs(string)
				puts string
			end
			
			def alert(string)
				if not @wvref then
					return false
				end
				@wvref.method_missing(:runJavaScript, "alert(\"#{string}\")")
				return true
			end
			
			def jsdecl(varn, varv)
				if not @wvref then
					return false
				end
				if String === varv then
					varv = '"' + varv.gsub('"', '\"') + '"'
				elsif Hash === varv then
					varv = varv.clone.to_json
				end
				cmd = "#{varn} = #{varv}"
				@wvref.method_missing(:runJavaScript, cmd)
				return true
			end
			
			def valmod(id, val)
				if not @wvref then
					return nil
				end
				prependc = '"'
				if not String === val then
					prependc = ''
				end
				val = prependc + val.to_s.gsub('"', '\"') + prependc
				@wvref.method_missing(:runJavaScript, "document.getElementById(\"#{id}\").value = #{val}")
				return val
			end
			
			def jsrun(string)
				if not @wvref then
					return false
				end
				@wvref.method_missing(:runJavaScript, string.gsub('"', '\"'))
				return true
			end
			
			def prompt(string)
				if not @wvref then
					return nil
				end
				result = nil
				@wvref.method_missing(:runJavaScript, "prompt(\"#{string}\")", proc { |v| result = v || '' })
				while result == nil do
					sleep 0.02
				end
				return result
			end
			
			def jsquit
				puts "Application terminated as specified in JavaScript."
				QML.application.quit
			end
		end
	end
end

# @!visibility private
def start_htmlui_browser
	QML.run do |app| 
		app.load_path File.absolute_path(File.dirname(__FILE__)) + '/minibrowser.qml'
	end
end
