Gem::Specification.new do |s|
  s.name        = 'dead-man'
  s.version     = '0.0.2'
  s.date        = '2014-08-13'
  s.summary     = "The dead man's switch"
  s.description = "Know when your systems are dead."
  s.authors     = ["Sean Coleman"]
  s.email       = 'sean@seancoleman.net'
  s.files       = ["lib/dead_man.rb", "lib/dead_man/switch.rb", "lib/dead_man/heartbeat.rb"]
  s.homepage    = 'http://rubygems.org/gems/hola'
  # s.license     = 'MIT'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'timecop'
  s.add_dependency 'redis'
  s.add_dependency 'activesupport'
end