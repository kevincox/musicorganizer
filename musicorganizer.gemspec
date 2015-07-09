require File.join(__FILE__, '../lib/version')

Gem::Specification.new do |s|
	s.name = 'musicorganizer'
	s.version = MusicOrganizer.VERSION_STR
	s.authors = ['Kevin Cox']
	s.email = ['kevincox@kevincox.ca']
	s.homepage = 'https://kevincox.ca/dev/null'
	s.summary = 'A music organizer.'
	# s.description = ''
	s.licenses = ['zlib']
	
	s.files = Dir['lib/**/*.rb', 'bin/**/*.rb', 'LICENSE', '*.md']
	s.test_files = Dir['spec/**/*.rb']
	s.require_path = 'lib'
	
	s.add_dependency 'activesupport'
	s.add_dependency 'ruby-taglib2'
	# s.add_development_dependency 'rspec', '~>3'
end
