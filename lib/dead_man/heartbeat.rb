module DeadMan
  module Heartbeat
    extend self

    def pulse(job)
      DeadMan.redis.set(job, Time.now.utc)
    end
  end
end
