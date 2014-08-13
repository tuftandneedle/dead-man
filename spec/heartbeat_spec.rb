require 'spec_helper'

describe DeadMan::Heartbeat do
  describe '.pulse' do
    it 'should record the job' do
      Timecop.freeze
      expect(DeadMan.redis).to receive(:set).with('job_to_track', Time.now.utc)
      DeadMan::Heartbeat.pulse('job_to_track')
    end
  end
end