FactoryGirl.define do

  factory :order, :class => Buckaroo::Ideal::Order do
    amount 20.00
    description "A test transaction"
    sequence(:reference) { |n| "test-reference-#{n}" }
    sequence(:invoice_number) { |n| "test-invoice-#{n}" }
  end

end
