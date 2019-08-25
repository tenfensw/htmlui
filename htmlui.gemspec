require 'rubygems'
require_relative 'lib/dialogbind.rb'

Gem::Specification.new do |gemdesc|
	gemdesc.name = 'htmlui'
	gemdesc.version = '1.0.0'
	gemdesc.author = [ 'Tim K' ]
	gemdesc.email = [ 'timprogrammer@rambler.ru' ]
	gemdesc.date = '2019-08-25'
	gemdesc.homepage = 'https://github.com/timkoi/htmlui'
	gemdesc.summary = 'DialogBind provides a portable Ruby API for creating simple message box-based interfaces that work on Linux, macOS and Windows.'
	gemdesc.description = 'DialogBind is a library providing a cross-platform API for creating dialog and message boxes from Ruby code. Docs are available here: https://www.rubydoc.info/gems/dialogbind/'
	gemdesc.files = [ 'lib/htmlui.rb', 'lib/htmlui/backend.rb', 'lib/htmlui/frontend.rb', 'lib/htmlui/minibrowser.qml' ]
	gemdesc.required_ruby_version = Gem::Requirement.new('>= 2.0.0')
	gemdesc.require_paths = [ 'lib' ]
	gemdesc.licenses = [ 'MIT' ]
	gemdesc.add_runtime_dependency('qml')
end
