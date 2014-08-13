module DeadMan
  module Heartbeat
    extend self

    def pulse(job)
      DeadMan::REDIS.set(job, Time.now.utc)
    end
  end
end
