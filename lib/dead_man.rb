require 'redis'
require 'pry'
require 'dead_man/switch.rb'
require 'dead_man/heartbeat.rb'

module DeadMan
  REDIS = Redis.new host: 'localhost', db: 8
end