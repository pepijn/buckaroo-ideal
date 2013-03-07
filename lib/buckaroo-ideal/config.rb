module Buckaroo
  module Ideal
    #
    # Configuration singleton for storing settings required for making
    # transactions.
    #
    class Config
      class << self
        # The gateway URL that is used to post form data to.
        #
        # @return [String] The gateway URL
        attr_accessor :gateway_url

        # The merchant-key is supllied by Buckaroo. Every application MUST have
        # it's own merchant key.
        #
        # @return [String] The merchant-key for the application
        attr_accessor :merchant_key

        # This allows you to pre-select the method of payment for the customer
        #
        # @return [String] The preferred payment method
        attr_accessor :payment_method

        # The secret_key should only be known by your application and Buckaroo.
        # It is used to sign orders and validate transactions.
        #
        # @return [String] The shared secret key that is used to sign
        #   transaction requests
        attr_accessor :secret_key

        # @return [String] The URL the user will be redirected to after a
        #   successful transaction
        attr_accessor :success_url

        # @return [String] The URL the user will be redirected to after a failed
        #   transaction
        attr_accessor :reject_url

        # @return [String] The URL the user will be redirected to after an error
        #   occured during the transaction
        attr_accessor :error_url

        # Default settings
        def defaults
          {
            :gateway_url     => 'https://testcheckout.buckaroo.nl/html/',
            :merchant_key    => nil,
            :payment_method  => nil,
            :secret_key      => nil,
            :success_url     => nil,
            :reject_url      => nil,
            :error_url       => nil
          }
        end

        # Configure the integration with Buckaroo
        def configure(settings = {})
          defaults.merge(settings).each do |key, value|
            set key, value
          end
        end

        # Reset the configuration to the default values
        def reset
          configure({})
        end

        private

        def set(key, value)
          instance_variable_set(:"@#{key}", value)
        end
      end
    end
  end
end
