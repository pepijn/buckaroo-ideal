require 'spec_helper'

describe Buckaroo::Ideal::Response do
  let(:parameters) {
    {
      "brq_payment" => "B0440C23E6624C118804C7822C7FA8C6",
      "brq_payment_method" => "ideal",
      "brq_statuscode" => "190",
      "brq_statuscode_detail" => "S001",
      "brq_statusmessage" => "Payment+successfully+processed",
      "brq_invoicenumber" => "edh-invoice-34",
      "brq_amount" => "25.00",
      "brq_currency" => "EUR",
      "brq_test" => "true",
      "brq_timestamp" => "2013-03-08+17:59:00",
      "brq_SERVICE_ideal_consumerIssuer" => "ING",
      "brq_SERVICE_ideal_consumerName" => "J.+de+Tester",
      "brq_SERVICE_ideal_consumerIBAN" => "testiban",
      "brq_SERVICE_ideal_consumerBIC" => "BUCKBIC",
      "brq_transactions" => "02DCB71B728742A0BD9E38CD440E4D9B",
      "brq_signature" => "longandmostlyillegiblestringhere"
    }
  }

  let(:response) { Buckaroo::Ideal::Response.new(parameters) }

  it 'has a transaction_id' do
    response.transaction_id.should == '02DCB71B728742A0BD9E38CD440E4D9B'
  end

  it 'has a status' do
    response.status.should == Buckaroo::Ideal::Status.new('190')
  end

  it 'has an invoice_number' do
    response.invoice_number.should == 'edh-invoice-34'
  end

  it 'has a reference' do
    response.reference.should == 'B0440C23E6624C118804C7822C7FA8C6'
  end

  it 'has a signature' do
    response.signature.should == 'longandmostlyillegiblestringhere'
  end

  it 'has an amount' do
    response.amount.should == "25.00"
  end

  it 'has a currency' do
    response.currency.should == 'EUR'
  end

  it 'has a time' do
    response.time.should == Time.local(2013, 3, 8, 17, 59, 0)
  end

  it 'has a timestamp' do
    response.timestamp.should == '2013-03-08+17:59:00'
  end

  describe '#valid?' do
    it 'returns true if the signature is valid' do
      valid_signature = Object.new
      valid_signature.stub(:to_s).and_return 'longandmostlyillegiblestringhere'
      response.signature_class = valid_signature

      response.should be_valid
    end

    it 'returns false if the signature if not valid' do
      Buckaroo::Ideal::Config.stub(:secret_key).and_return('secret_key')
      invalid_signature = Object.new
      invalid_signature.stub(:to_s).and_return 'shortstring'
      response.signature_class = invalid_signature

      response.should_not be_valid
    end
  end
end
