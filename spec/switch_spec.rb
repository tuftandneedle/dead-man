require 'spec_helper'

describe DeadMan::Switch do
  before (:all) do
    Timecop.freeze(Time.new(2014, 8, 1, 10, 55, 0))
    DeadMan::Switch::SWITCHES.clear
    DeadMan::Switch.register_switch 'job1.run', 1.minute
    DeadMan::Switch.register_switch 'job2.run', 3.hours

    @callback = -> (message) { "better #{message}" }
    DeadMan::Switch.register_callback(@callback)
  end

  describe '.run' do
    it 'should check all registered jobs' do
      expect(DeadMan::Switch).to receive(:check).with('job1.run')
      expect(DeadMan::Switch).to receive(:check).with('job2.run')
      DeadMan::Switch.run
    end
  end

  describe '.check' do
    context 'with unknown check' do
      it 'should return false' do
        expect(DeadMan::Switch::SWITCHES).to receive(:has_key?).with('unknown_job.run').and_return(false)
        expect(DeadMan::Switch).to_not receive(:alert)
        expect(DeadMan::Switch.check('unknown_job.run')).to be_falsey
      end
    end

    context 'with alertable time' do
      it 'should create a notification' do
        expect(DeadMan::Switch::SWITCHES).to receive(:has_key?).with('job1.run').and_return(true)
        expect(DeadMan::Switch).to receive(:last_heartbeat_at).with('job1.run').and_return(90.seconds.ago)
        expect(DeadMan::Switch).to receive(:alertable?).with(90.seconds.ago, 1.minute).and_return(true)
        expect(DeadMan::Switch).to receive(:alert).with('job1.run', 90.seconds.ago)
        DeadMan::Switch.check('job1.run')
      end
    end

    context 'with valid time' do
      it 'should not create a notification' do
        expect(DeadMan::Switch::SWITCHES).to receive(:has_key?).with('job1.run').and_return(true)
        expect(DeadMan::Switch).to receive(:last_heartbeat_at).with('job1.run').and_return(30.seconds.ago)
        expect(DeadMan::Switch).to receive(:alertable?).with(30.seconds.ago, 1.minute).and_return(false)
        expect(DeadMan::Switch).to_not receive(:alert)
        DeadMan::Switch.check('job1.run')
      end
    end

    context 'with a invalid last stored heartbeat' do
      it 'should create an error notification' do
        message = 'Check failed for job1.run. This is usually because an improper heartbeat timestamp was stored.'
        expect(DeadMan::Switch).to receive(:last_heartbeat_at).with('job1.run').and_return('unknown value')
        expect(DeadMan::Switch).to receive(:notify).with(message)
        DeadMan::Switch.check('job1.run')
      end
    end
  end

  describe '.register_callback' do
    it 'should add a callback' do
      expect(DeadMan::Switch::CALLBACKS).to include(@callback)
    end
  end

  describe '.register_switch' do
    it 'should add switches with the proper intervals' do
      expect(DeadMan::Switch::SWITCHES['job1.run']).to eq(1.minute)
      expect(DeadMan::Switch::SWITCHES['job2.run']).to eq(3.hours)
    end
  end

  describe '.alertable?' do
    context 'with an expired timestamp' do
      it 'should return true' do
        expect(DeadMan::Switch.alertable?(90.seconds.ago, 30.seconds)).to be_truthy
      end
    end

    context 'with a non-expired timestamp' do
      it 'should return false' do
        expect(DeadMan::Switch.alertable?(20.minutes.ago, 30.minutes)).to be_falsey
      end
    end
  end

  describe '.alert' do
    it 'should create an alert message' do
      message = 'job1.run last ran at timestamp'
      expect(DeadMan::Switch).to receive(:notify).with('job1.run died. The switch was last triggered at 2014-08-01 10:35:00 -0700')
      DeadMan::Switch.alert('job1.run', 20.minutes.ago)
    end
  end

  describe '.notify' do
    it 'should call callbacks' do
      message = 'job last ran a while ago'
      expect(@callback).to receive(:call).with(message)
      DeadMan::Switch.notify(message)
    end
  end

  describe '.adjusted_interval' do
    it 'should return 20% more than interval' do
      expect(DeadMan::Switch.adjusted_interval(2.minutes)).to eq(2.4.minutes)
    end
  end
end