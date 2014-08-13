module DeadMan
  module Switch
    INTERVAL_THRESHOLD = 0.2
    SWITCHES = {}
    CALLBACKS = []
    extend self

    def run
      SWITCHES.each_key do |switch|
        check(switch)
      end
    end

    def register_callback(callback)
      CALLBACKS << callback
    end

    def register_switch(name, interval)
      SWITCHES[name] = interval
    end

    def check(switch)
      if SWITCHES.has_key?(switch)
        timestamp = last_heartbeat_at(switch)
        raise 'Unrecorded switch' if timestamp.nil?
        alert(switch, timestamp) if alertable?(timestamp, SWITCHES[switch])
      else
        return false
      end
    rescue
      notify("Check failed for #{switch}. This is usually because an improper heartbeat timestamp was stored.")
    end

    def last_heartbeat_at(switch)
      Time.zone.parse(DeadMan::REDIS.get(switch))
    rescue
      return nil
    end

    def alertable?(hearbeat_at, interval)
      hearbeat_at < adjusted_interval(interval).ago
    end

    def adjusted_interval(interval)
      interval + interval * INTERVAL_THRESHOLD
    end

    def alert(switch, timestamp)
      notify("#{switch} died. The switch was last triggered at #{timestamp}")
    end

    def notify(message)
      CALLBACKS.each do |callback|
        callback.call(message)
      end
    end
  end
end