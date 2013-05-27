require 'spec_helper'

describe Buckaroo::Ideal::TransactionRequest do
  let(:order)   { Buckaroo::Ideal::Order.new          }
  let(:request) { Buckaroo::Ideal::TransactionRequest.new(order) }

  before do
    Buckaroo::Ideal::Config.configure(
      :merchant_key    => 'merchant_key',
      :secret_key      => 'secret_key',
      :test_mode       => true,
      :success_url     => 'http://example.com/transaction/success'
    )
  end

  it 'modifies the process url to reflect the transaction type' do
    wanted_url = 'https://testcheckout.buckaroo.nl/nvp/?op=TransactionRequest'
    request.gateway_url.should == wanted_url
  end
end
