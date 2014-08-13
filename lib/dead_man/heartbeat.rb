module DeadMan
  module Heartbeat
    extend self

    def pulse(job)
      key = DeadMan.key(job)
      DeadMan.redis.set(key, Time.now.utc)
    end
  end
end
