require 'spec_helper'

describe Buckaroo::Ideal::Signature do
  it "should concatenate all key-value pairs that will be sent" do
    parameters = {a: 1, b: 2}
    signature = Buckaroo::Ideal::Signature.new(parameters)
    signature.content_for_signature.should eql "a1b2"
  end

  it "should sort the parameters to be signed by key" do
    parameters = {b: 2, a: 1}
    signature = Buckaroo::Ideal::Signature.new(parameters)
    signature.content_for_signature.should eql "a1b2"
  end

  it "should sort parameters case-insensitively but conserve case" do
    parameters = {C: 3, b: 2, A: 1}
    signature = Buckaroo::Ideal::Signature.new(parameters)
    signature.content_for_signature.should eql "A1b2C3"
  end

  it "should url-decode all values before concatenating" do
    parameters = {a: 'jolly+rogers', b: 'test'}
    signature = Buckaroo::Ideal::Signature.new(parameters)
    signature.content_for_signature.should eql 'ajolly rogersbtest'
  end

  it "should append the secret key to the content for signature before signing" do
    parameters = {a: 'test', b: 'test'}
    Buckaroo::Ideal::Config.stub(:secret_key).and_return('secret_key')
    Digest::SHA1.should_receive(:hexdigest).with("atestbtestsecret_key")
    Buckaroo::Ideal::Signature.new(parameters).to_s
  end
end
