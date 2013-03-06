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
      :return_method   => 'GET',
      :style           => 'POPUP',
      :autoclose_popup => true
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

  it 'has a default return_method from the configuration' do
    request.return_method.should == 'GET'
  end

  it 'has a default style from the configuration' do
    request.style.should == 'POPUP'
  end

  it 'has a default autoclose_popup from the configuration' do
    request.autoclose_popup.should be_true
  end

  describe '#gateway_url' do
    it 'returns the configured gateway_url' do
      request.gateway_url.should == Buckaroo::Ideal::Config.gateway_url
    end
  end

  describe '#parameters' do
    def parameters; request.parameters; end

    it 'has a BRQ_websitekey with the configured merchant_key' do
      parameters['BRQ_websitekey'].should == 'merchant_key'

      Buckaroo::Ideal::Config.merchant_key = 'new_merchant_key'
      parameters['BRQ_websitekey'].should == 'new_merchant_key'
    end

    it "has a BRQ_amount with the order's amount as a float" do
      order.amount = 19.95
      parameters['BRQ_amount'].should == 19.95
    end

    it "has a BRQ_currency with the order's currency" do
      parameters['BRQ_currency'].should == 'EUR'

      order.currency = 'BHT'
      parameters['BRQ_currency'].should == 'BHT'
    end

    it "has a BRQ_invoicenumber with the order's invoice_number" do
      order.invoice_number = 'INV001'
      parameters['BRQ_invoicenumber'].should == 'INV001'
    end

    it 'has a generated BRQ_Signature2' do
      parameters['BRQ_Signature2'].length.should == 40

      request.stub(:signature).and_return('signature')

      parameters['BRQ_Signature2'].should == 'signature'
    end

    it 'has a BRQ_culture with the language' do
      parameters['BRQ_culture'].should == 'nl-NL'

      request.culture = 'en-US'
      parameters['BRQ_culture'].should == 'en-US'
    end

    it "has a BRQ_Issuer if the order's bank is set" do
      parameters.keys.should_not include 'BRQ_Issuer'

      order.bank = 'ABNAMRO'
      parameters['BRQ_Issuer'].should == 'ABNAMRO'
    end

    it "has a BRQ_Description if the order's description is set" do
      parameters.keys.should_not include 'BRQ_Description'

      order.description = 'Your Order Description'
      parameters['BRQ_Description'].should == 'Your Order Description'
    end

    it 'has a BRQ_Reference if the reference is set' do
      parameters.keys.should_not include 'BRQ_Reference'

      order.reference = 'Reference'
      parameters['BRQ_Reference'].should == 'Reference'
    end

    it 'has a BRQ_Return_Success if the success_url is set' do
      request.success_url = nil
      parameters.keys.should_not include 'BRQ_Return_Success'

      request.success_url = 'http://example.org/'
      parameters['BRQ_Return_Success'].should == 'http://example.org/'
    end

    it 'has a BRQ_Return_Reject if the reject_url is set' do
      request.reject_url = nil
      parameters.keys.should_not include 'BRQ_Return_Reject'

      request.reject_url = 'http://example.org/'
      parameters['BRQ_Return_Reject'].should == 'http://example.org/'
    end

    it 'has a BRQ_Return_Error if the error_url is set' do
      request.error_url = nil
      parameters.keys.should_not include 'BRQ_Return_Error'

      request.error_url = 'http://example.org/'
      parameters['BRQ_Return_Error'].should == 'http://example.org/'
    end
  end
end
