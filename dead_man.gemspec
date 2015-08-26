Gem::Specification.new do |s|
  s.name        = 'dead-man'
  s.version     = '0.0.7'
  s.date        = '2015-08-26'
  s.summary     = "A dead man's switch for monitoring jobs."
  s.description = "DeadMan is an implementation of a dead man's switch to monitor jobs. It's a simple tool that gives visibility when jobs fail to run."
  s.authors     = ["Sean Coleman"]
  s.email       = 'sean@seancoleman.net'
  s.files       = ["lib/dead_man.rb", "lib/dead_man/switch.rb", "lib/dead_man/heartbeat.rb"]
  s.homepage    = 'https://github.com/tuftandneedle/dead-man'
  s.license     = 'MIT'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'timecop'
  s.add_dependency 'redis'
  s.add_dependency 'activesupport'
end
