require 'active_support/core_ext/module/delegation'

module Buckaroo
  module Ideal
    class Order
      def self.defaults
        {
          :currency => 'EUR',
          :secret_key => Config.secret_key,
          :merchant_key => Config.merchant_key,
          :success_url => Config.success_url,
          :reject_url  => Config.reject_url,
          :error_url => Config.error_url
        }
      end

      # @return [String] The merchant key for this order.
      attr_accessor :merchant_key

      # @return [String] The secret key for this order.
      attr_accessor :secret_key

      # @return [Float] The total amount that this order is for.
      attr_accessor :amount

      # @return [String] The currency that is being used for the transaction.
      attr_accessor :currency

      # @return [String] The bank that will be used for the order's transaction.
      attr_accessor :bank

      # @return [String] The description for the transaction.
      attr_accessor :description

      # @return [String] The reference that will be passed to the response URLs.
      attr_accessor :reference

      # @return [String] The invoice number that is associated with the order.
      attr_accessor :invoice_number

      # @return [String] The url the gateway should return the request to upon successful completion.
      attr_accessor :success_url

      # @return [String] The url the gateway should return the request to upon order rejection.
      attr_accessor :reject_url

      # @return [String] The url the gateway should return the request if it encounters an error.
      attr_accessor :error_url

      # Initialize a new +Order+ with the given settings. Uses the defaults from
      # +Buckaroo::Ideal::Order.defaults+ for settings that are not specified.
      #
      # @return [Buckaroo::Ideal::Order] The +Order+ instance
      def initialize(settings = {})
        settings = self.class.defaults.merge(settings)
        settings.each do |key, value|
          set key, value
        end
      end

      private

      def set(key, value)
        instance_variable_set(:"@#{key}", value)
      end
    end
  end
end
