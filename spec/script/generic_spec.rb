require 'spec_helper'

describe Travis::Build::Script::Generic do
  let(:options) { { logs: { build: false, state: false } } }
  let(:data)    { PAYLOADS[:push].deep_clone }

  subject { described_class.new(data, options).compile }

  it_behaves_like 'a build script'

  it 'with timeouts set to false it does not timeout commands' do
    data.update(timeouts: false)
    subject.should_not =~ /travis_timeout [\d]+/
    store_example 'no_timeouts'
  end

  it 'with logs set to false it does not log commands' do
    options.update(logs: { build: false, state: false })
    subject.should_not =~ />> build.log/
    store_example 'no_logs'
  end

  describe 'an error is raised during compilation' do
    before do
      described_class.any_instance.stubs(:raw).raises(StandardError, 'boom')
    end

    it 'wraps the error in a CompileError' do
      lambda { subject }.should raise_error(Travis::Build::Script::CompileError)
    end
  end
end

