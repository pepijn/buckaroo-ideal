require 'spec_helper'

describe Buckaroo::Ideal::Signature do
  it 'should only include fields with the prefixes brq_, add_ or cust_ for signature calculations' do
    parameters = {brq_a: 'boring', b: 'test', add_some_field: 'longstringhere', cust_other_field: 'blah'}
    signature = Buckaroo::Ideal::Signature.new(parameters)
    signature.content_for_signature.should eql 'add_some_field=longstringherebrq_a=boringcust_other_field=blah'
  end

  it 'should disregard the "brq_signature" field for creating the signature' do
    parameters = {brq_a: 'jolly+rogers', brq_b: 'test', brq_signature: 'longstringhere'}
    signature = Buckaroo::Ideal::Signature.new(parameters)
    signature.content_for_signature.should eql 'brq_a=jolly rogersbrq_b=test'
  end

  it "should concatenate all relevant key-value pairs" do
    parameters = {brq_a: 1, brq_b: 2}
    signature = Buckaroo::Ideal::Signature.new(parameters)
    signature.content_for_signature.should eql "brq_a=1brq_b=2"
  end

  it "should sort the parameters to be signed by key" do
    parameters = {brq_b: 2, brq_a: 1}
    signature = Buckaroo::Ideal::Signature.new(parameters)
    signature.content_for_signature.should eql "brq_a=1brq_b=2"
  end

  it "should sort parameters case-insensitively but conserve case" do
    parameters = {brq_C: 3, brq_b: 2, brq_A: 1}
    signature = Buckaroo::Ideal::Signature.new(parameters)
    signature.content_for_signature.should eql "brq_A=1brq_b=2brq_C=3"
  end

  it "should url-decode all values before concatenating" do
    parameters = {brq_a: 'jolly+rogers', brq_b: 'test'}
    signature = Buckaroo::Ideal::Signature.new(parameters)
    signature.content_for_signature.should eql 'brq_a=jolly rogersbrq_b=test'
  end

  it "should append the secret key to the content for signature before signing" do
    parameters = {brq_a: 'test', brq_b: 'test'}
    Buckaroo::Ideal::Config.stub(:secret_key).and_return('secret_key')
    Digest::SHA1.should_receive(:hexdigest).with("brq_a=testbrq_b=testsecret_key")
    Buckaroo::Ideal::Signature.new(parameters).to_s
  end
end
