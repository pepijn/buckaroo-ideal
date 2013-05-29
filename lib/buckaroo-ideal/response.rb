require 'active_support/core_ext/module/delegation'
require 'time'

module Buckaroo
  module Ideal
    class Response
      # @return [Hash] The raw parameters that form the heart of the response
      attr_reader :parameters

      attr_accessor :signature_class

      def initialize(params = {}, secret_key = Config.secret_key)

        @parameters     = params
        @secret_key     = secret_key
        set_parameters
      end

      def valid?
        @signature == signature_class.to_s
      end

      def signature_class
        @signature_class ||= Signature.new(parameters, @secret_key)
      end

      private

      include Util
    end
  end
end
