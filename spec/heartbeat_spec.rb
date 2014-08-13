require 'spec_helper'

describe DeadMan::Heartbeat do
  describe '.pulse' do
    it 'should record the job' do
      Timecop.freeze
      expect(DeadMan).to receive(:key).with('job_to_track').and_return('dead-man:job_to_track')
      expect(DeadMan.redis).to receive(:set).with('dead-man:job_to_track', Time.now.utc)
      DeadMan::Heartbeat.pulse('job_to_track')
    end
  end
end