require 'spec_helper'

describe Buckaroo::Ideal::Status do
  let(:status) { Buckaroo::Ideal::Status.new('190') }

  describe '#initialize' do
    it 'returns a Status with the code given' do
      status = Buckaroo::Ideal::Status.new('190')
      status.code.should == '190'
    end

    it 'returns a Status with the message of the given code' do
      status = Buckaroo::Ideal::Status.new('190')
      status.message.should == 'Payment success'
    end

    it 'throws an UnknownStatusCode exception if the given code is invalid' do
      expect {
        Buckaroo::Ideal::Status.new('000')
      }.to raise_error Buckaroo::Ideal::Status::UnknownStatusCode
    end
  end

  describe '#==' do
    it 'returns true if the statuses have the same code' do
      Buckaroo::Ideal::Status.new('190').should == Buckaroo::Ideal::Status.new('190')
    end
  end

  describe '#state' do
    it "returns :completed for code 190 (Payment success)" do
      status = Buckaroo::Ideal::Status.new("190")
      status.state.should == :completed
    end

    %w(790 791 792 793).each do |code|
      message = Buckaroo::Ideal::Status::STATUS_CODES[code]

      it "returns :pending for code #{code} (#{message})" do
        status = Buckaroo::Ideal::Status.new(code)
        status.state.should == :pending
      end
    end

    %w(490 491 492 690 890 891).each do |code|
      message = Buckaroo::Ideal::Status::STATUS_CODES[code]

      it "returns :unknown for code #{code} (#{message})" do
        status = Buckaroo::Ideal::Status.new(code)
        status.state.should == :failed
      end
    end
  end

  describe '#completed?' do
    it 'returns true if the state is completed' do
      status.stub(:state).and_return(:completed)
      status.should be_completed
    end

    it 'returns false if the state is not completed' do
      status.stub(:state).and_return(:unknown)
      status.should_not be_completed
    end
  end

  describe '#pending?' do
    it 'returns true if the state is pending' do
      status.stub(:state).and_return(:pending)
      status.should be_pending
    end

    it 'returns false if the state is not pending' do
      status.stub(:state).and_return(:unknown)
      status.should_not be_pending
    end
  end

  describe '#failed?' do
    it 'returns true if the state is failed' do
      status.stub(:state).and_return(:failed)
      status.should be_failed
    end

    it 'returns false if the state is not failed' do
      status.stub(:state).and_return(:unknown)
      status.should_not be_failed
    end
  end
end
