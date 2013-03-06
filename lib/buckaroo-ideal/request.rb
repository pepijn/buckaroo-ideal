require 'active_support/core_ext/module/delegation'

module Buckaroo
  module Ideal
    #
    # A class to help with the generation of payment forms for the Buckaroo
    # Payment Gateway.
    #
    # A form has a number of required parameters that are retreived from the
    # +Buckaroo::Idea::Order+:
    # * +currency+ -- required; but set by default to 'EUR'
    # * +invoice_number+ -- required; not set by default
    # * +amount+ -- required; this is the whole amount, it is automatically
    #   converted to cents
    # * +bank+ -- optional
    # * +description+ -- optional
    #
    # It is possible to set the following options for this form:
    # * +language+ -- required, defaults to 'NL'
    # * +reference+ -- optional
    # * +success_url+ -- optional according to documentation
    # * +reject_url+ -- optional
    # * +error_url+ -- optional
    #
    # The +gateway_url+ and +merchant_key+ are read from
    # +Buckaroo::Ideal::Config+.
    #
    # To access the information required to create a form, instantiate a new
    # +Buckaroo::Ideal::Request+ with an +Buckaroo::Ideal::Order+ instance:
    #
    #     order   = Buckaroo::Ideal::Order.new(amount: 100, invoice_number: 'EETNU-123')
    #     request = Buckaroo::Ideal::Request.new(order)
    #
    # You can then use the information to create a form. An example in Rails:
    #
    #     <%= form_tag request.gateway_url do %>
    #       <% request.parameters.each do |name, value| %>
    #         <%= hidden_field_tag name, value %>
    #       <% end %>
    #       <%= submit_tag 'Proceed to payment' %>
    #     <% end %>
    class Request
      def self.defaults
        {
          :culture         => 'nl-NL',
          :success_url     => Config.success_url,
          :reject_url      => Config.reject_url,
          :error_url       => Config.error_url,
          :return_method   => Config.return_method,
          :style           => Config.style,
          :autoclose_popup => Config.autoclose_popup
        }
      end

      # @return [String] The configured gateway_url in +Buckaroo::Ideal::Config+
      delegate :gateway_url,  :to => Config

      # @return [String] The configured merchant_key in +Buckaroo::Ideal::Config+
      delegate :merchant_key, :to => Config

      # @return [Buckaroo::Ideal::Order] The order for which the payment request
      #   is being made
      attr_reader :order

      # @return [String] The language in which Buckaroo's user interface is
      #   presented. Represented as a culture, eg. 'nl-NL'
      attr_accessor :culture

      # Defaults to the configured +Buckaroo::Ideal::Config.success_url+, but
      # can be overwritten in the +Order+ instance.
      #
      # @return [String] The URL the user will be redirected to after a
      #   successful transaction
      attr_accessor :success_url

      # Defaults to the configured +Buckaroo::Ideal::Config.reject_url+, but can
      # be overwritten in the +Order+ instance.
      #
      # @return [String] The URL the user will be redirected to after a failed
      #   transaction
      attr_accessor :reject_url

      # Defaults to the configured +Buckaroo::Ideal::Config.error_url+, but can
      # be overwritten in the +Order+ instance.
      #
      # @return [String] The URL the user will be redirected to after an error
      #   occured during the transaction
      attr_accessor :error_url

      # Defaults to the configured +Buckaroo::Ideal::Config.return_method+, but
      # can be overwritten in the +Order+ instance.
      #
      # @return [String] The HTTP method that will be used to return the user
      #   back to the application after a transaction
      attr_accessor :return_method

      # Defaults to the configured +Buckaroo::Ideal::Config.style+, but can be
      # overwritten in the +Order+ instance.
      #
      # @return [String] The style that is being used
      attr_accessor :style

      # Defaults to the configured +Buckaroo::Ideal::Config.autoclose_popup+,
      # but can be overwritten in the +Order+ instance.
      #
      # @return [Boolean] Autoclose the popup after a transaction
      attr_accessor :autoclose_popup

      # Initialize a new +Buckaroo::Ideal::Request+ instance for the given
      # order.
      #
      # @param [Buckaroo::Ideal::Order] The order that needs to be signed.
      # @param [Hash] The settings for this form.
      # @return [Buckaroo::Ideal::Request] The form for the order instance.
      def initialize(order, settings = {})
        @order = order
        settings = self.class.defaults.merge(settings)
        settings.each do |key, value|
          set key, value
        end
      end

      def payload
        {
          'BRQ_currency'        => order.currency,
          'BRQ_invoicenumber'   => order.invoice_number,
          'BRQ_amount'          => order.amount,
          'BRQ_websitekey'      => merchant_key,
          'BRQ_culture'         => culture
        }.merge compact({
          'BRQ_Issuer'          => order.bank,
          'BRQ_Description'     => order.description,
          'BRQ_Reference'       => order.reference,
          'BRQ_Return_Success'  => success_url,
          'BRQ_Return_Reject'   => reject_url,
          'BRQ_Return_Error'    => error_url
        })
      end

      def parameters
        payload.merge({'BRQ_Signature2' => signature.to_s})
      end

      private

      def signature
        Buckaroo::Ideal::Signature.new(payload)
      end

      def set(key, value)
        instance_variable_set(:"@#{key}", value)
      end

      include Util
    end
  end
end
