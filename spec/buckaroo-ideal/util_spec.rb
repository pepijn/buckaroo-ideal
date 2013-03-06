# encoding: utf-8
require 'spec_helper'

describe Buckaroo::Ideal::Util do
  describe '#to_normalized_string' do
    it 'translates utf-8 characters to ASCII equivalents' do
      result = Buckaroo::Ideal::Util.to_normalized_string('îñtërnâtiônàlizâtiôn')
      result.should == 'internationalization'
    end

    it 'keeps dashes' do
      result = Buckaroo::Ideal::Util.to_normalized_string('order-123')
      result.should == 'order-123'
    end
  end

  describe '#compact' do
    it 'removes keys from hashes if they do not have a value' do
      result = Buckaroo::Ideal::Util.compact({ 'key' => nil })
      result.keys.should_not include 'key'
    end

    it 'preserves keys and values in hashes if they have a value' do
      result = Buckaroo::Ideal::Util.compact({ 'key' => 'value' })
      result.keys.should include 'key'
      result['key'].should == 'value'
    end
  end
end
