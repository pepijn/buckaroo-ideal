module Buckaroo
  module Ideal
    class TransactionRequest < Request
      def gateway_url
        "#{Config.gateway_url}?op=TransactionRequest"
      end
    end
  end
end
