require 'spec_helper'

describe DeadMan do
  subject { DeadMan }

  describe '.key' do
    it 'creates a namespaced key' do
      expect(subject.key('job.1')).to eq('dead-man:job.1')
    end
  end
end