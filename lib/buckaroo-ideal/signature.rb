require 'digest/sha1'
require 'active_support/core_ext/module/delegation'
require 'cgi'

module Buckaroo
  module Ideal
    #
    # Digital signature generator for all responses / requests.
    #
    # A digital signature is used to sign your request so the Buckaroo Payment
    # Service can validate that the request was made by your application.
    class Signature

      # @return [Buckaroo::Ideal::Order] The order that is being signed.
      attr_reader :parameters

      # @return [String] The secret_key used to sign (either passed in or
      # configured in +Buckaroo::Ideal::Config+).
      attr_reader :secret_key

      # Initialize a new +Buckaroo::Ideal::Signature+ instance for the given
      # parameters.
      #
      # @param [Hash] The parameters that needs to be signed.
      def initialize(parameters, secret_key = Config.secret_key)
        @secret_key = secret_key
        @parameters = parameters.tap {|h| h.delete(:brq_signature)}
      end

      def content_for_signature
        content = ""
        elligible_parameters = @parameters.select { |k, v|
          starts_with?(k, 'brq_') || starts_with?(k, 'add_') || starts_with?(k, 'cust_')
        }

        elligible_parameters.sort{ |a, b|
          a[0].downcase <=> b[0].downcase
          }.each { |k, v| content += "#{k}=#{::CGI::unescape v.to_s}" }
        content
      end

      def signature
        Digest::SHA1.hexdigest(content_for_signature + secret_key)
      end
      alias_method :to_s, :signature

      private

      include Util
    end
  end
end
