require 'active_support/core_ext/module/delegation'
require 'time'

module Buckaroo
  module Ideal
    class Response
      # @return [Hash] The raw parameters that form the heart of the response
      attr_reader :parameters

      # @return [String] The unique code that is given to the transaction by
      #   Buckaroo's Payment Gateway
      attr_reader :transaction_id

      # @return [Buckaroo::Ideal::Status] The status of the transaction
      attr_reader :status

      # @return [String] The reference that was given to the
      #   +Buckaroo::Ideal::Order+
      attr_reader :reference

      # @return [String] The invoice_number that was given to the
      #   +Buckaroo::Ideal::Order+
      attr_reader :invoice_number

      # @return [Buckaroo::Ideal::ResponseSignature] The signature of the
      #   transaction, which can be used to validate it's authenticity.
      attr_reader :signature

      # @return [String] The currency that was used during the transaction
      attr_reader :currency

      # @return [Time] The date and time of the transaction
      attr_reader :time

      # @return [String] The timestamp of the transaction
      attr_reader :timestamp

      # @return [Float] The amount that was transferred during the transaction
      attr_reader :amount

      attr_accessor :signature_class

      def initialize(params = {})
        @parameters     = params
        @transaction_id = parameters['brq_transactions']
        @reference      = parameters['brq_payment']
        @invoice_number = parameters['brq_invoicenumber']
        @currency       = parameters['brq_currency']
        @timestamp      = parameters['brq_timestamp']
        @time           = Time.parse(timestamp)
        @amount         = parameters['brq_amount']
        @status         = Status.new(parameters['brq_statuscode'])
        @signature      = parameters['brq_signature']
      end

      def valid?
        @signature == signature_class.to_s
      end

      def signature_class
        @signature_class ||= Signature.new(parameters)
      end

      private

      include Util
    end
  end
end
