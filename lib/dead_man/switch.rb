module DeadMan
  module Switch
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
      key = DeadMan.key(switch)
      timestamp = DeadMan.redis.get(key)
      Time.parse(timestamp)
    rescue
      return nil
    end

    def alertable?(heartbeat_at, interval)
      heartbeat_at < adjusted_interval(interval).ago
    end

    # Gives a padding on interval
    # e.g. 1 minute -> 6 minutes
    def adjusted_interval(interval)
      interval + 5.minutes
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
