$LOAD_PATH << File.expand_path('..', __FILE__)

module Buckaroo
  module Ideal
    # The banks that are supported by Buckaroo's iDEAL platform
    BANKS = %w[ ABNAMRO  ASNBANK  FRIESLAND
                INGBANK  RABOBANK SNSBANK
                SNSREGIO TRIODOS  LANSCHOT  ]

    # The currencies that are supported by Buckaroo's iDEAL platform
    CURRENCIES = %w[ EUR ]

    # The languages supported by Buckaroo's user interface:
    LANGUAGES = %w[ NL EN DE FR ]

    autoload :VERSION,                  'buckaroo-ideal/version'
    autoload :Config,                   'buckaroo-ideal/config'
    autoload :Order,                    'buckaroo-ideal/order'
    autoload :Response,                 'buckaroo-ideal/response'
    autoload :ResponseFactory,          'buckaroo-ideal/response_factory'
    autoload :FailResponse,             'buckaroo-ideal/fail_response'
    autoload :Signature,                'buckaroo-ideal/signature'
    autoload :Request,                  'buckaroo-ideal/request'
    autoload :TransactionRequest,       'buckaroo-ideal/transaction_request'
    autoload :TransactionStatusRequest, 'buckaroo-ideal/transaction_status_request'
    autoload :RefundInfoRequest,        'buckaroo-ideal/refund_info_request'
    autoload :Status,                   'buckaroo-ideal/status'
    autoload :Util,                     'buckaroo-ideal/util'
  end
end
