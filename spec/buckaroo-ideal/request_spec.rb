require 'spec_helper'

describe Buckaroo::Ideal::Request do
  let(:order)   { Buckaroo::Ideal::Order.new          }
  let(:request) { Buckaroo::Ideal::Request.new(order) }

  before do
    Buckaroo::Ideal::Config.configure(
      :merchant_key    => 'merchant_key',
      :secret_key      => 'secret_key',
      :test_mode       => true,
      :success_url     => 'http://example.com/transaction/success',
      :reject_url      => 'http://example.com/transaction/reject',
      :error_url       => 'http://example.com/transaction/error',
    )
  end

  it 'has a default culture' do
    request.culture.should == 'nl-NL'
  end

  it 'has a default success_url from the configuration' do
    request.success_url.should == 'http://example.com/transaction/success'
  end

  it 'has a default reject_url from the configuration' do
    request.reject_url.should == 'http://example.com/transaction/reject'
  end

  it 'has a default error_url from the configuration' do
    request.error_url.should == 'http://example.com/transaction/error'
  end

  describe '#gateway_url' do
    it 'returns the configured gateway_url' do
      request.gateway_url.should == Buckaroo::Ideal::Config.gateway_url
    end
  end

  describe '#parameters' do
    def parameters; request.parameters; end

    it 'has a brq_websitekey from the parameters' do
      parameters['brq_websitekey'].should == 'merchant_key'

      Buckaroo::Ideal::Config.merchant_key = 'new_merchant_key'
      parameters['brq_websitekey'].should == 'merchant_key'
    end

    it "has a brq_amount with the order's amount as a float" do
      order.amount = 19.95
      parameters['brq_amount'].should == 19.95
    end

    it "has a brq_currency with the order's currency" do
      parameters['brq_currency'].should == 'EUR'

      order.currency = 'BHT'
      parameters['brq_currency'].should == 'BHT'
    end

    it "has a brq_invoicenumber with the order's invoice_number" do
      order.invoice_number = 'INV001'
      parameters['brq_invoicenumber'].should == 'INV001'
    end

    it 'has a generated brq_signature' do
      parameters['brq_signature'].length.should == 40

      request.stub(:signature).and_return('signature')

      parameters['brq_signature'].should == 'signature'
    end

    it 'has a brq_culture with the language' do
      parameters['brq_culture'].should == 'nl-NL'

      request.culture = 'en-US'
      parameters['brq_culture'].should == 'en-US'
    end

    it "has a brq_issuer if the order's bank is set" do
      parameters.keys.should_not include 'brq_issuer'

      order.bank = 'ABNAMRO'
      parameters['brq_issuer'].should == 'ABNAMRO'
    end

    it "has a brq_description if the order's description is set" do
      parameters.keys.should_not include 'brq_description'

      order.description = 'Your Order Description'
      parameters['brq_description'].should == 'Your Order Description'
    end

    it 'has a brq_reference if the reference is set' do
      parameters.keys.should_not include 'brq_reference'

      order.reference = 'Reference'
      parameters['brq_reference'].should == 'Reference'
    end

    it "returns success_url as brq_return so as to have a sensible default" do
      request.success_url = nil
      parameters.keys.should_not include 'brq_return'

      request.success_url = 'http://example.org/'
      parameters['brq_return'].should == 'http://example.org/'
    end

    it 'has a brq_return_success if the success_url is set' do
      request.success_url = nil
      parameters.keys.should_not include 'brq_return_success'

      request.success_url = 'http://example.org/'
      parameters['brq_return_success'].should == 'http://example.org/'
    end

    it 'has a brq_return_reject if the reject_url is set' do
      request.reject_url = nil
      parameters.keys.should_not include 'brq_return_reject'

      request.reject_url = 'http://example.org/'
      parameters['brq_return_reject'].should == 'http://example.org/'
    end

    it 'has a brq_return_error if the error_url is set' do
      request.error_url = nil
      parameters.keys.should_not include 'brq_return_error'

      request.error_url = 'http://example.org/'
      parameters['brq_return_error'].should == 'http://example.org/'
    end
  end
end
