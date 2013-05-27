module Buckaroo
  module Ideal
    class TransactionStatusRequest < Request
      def gateway_url
        "#{Config.gateway_url}?op=TransactionStatusRequest"
      end
    end
  end
end
