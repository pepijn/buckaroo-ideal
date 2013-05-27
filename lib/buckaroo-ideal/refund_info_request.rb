module Buckaroo
  module Ideal
    class RefundInfoRequest < Request
      def gateway_url
        "#{Config.gateway_url}?op=RefundInfo"
      end
    end
  end
end
