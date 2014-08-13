require 'redis'
require 'dead_man/switch.rb'
require 'dead_man/heartbeat.rb'

module DeadMan
  extend self
  attr_accessor :redis
  @redis = Redis.new host: 'localhost', db: 8

  def key(switch)
    "dead-man:#{switch}"
  end
end