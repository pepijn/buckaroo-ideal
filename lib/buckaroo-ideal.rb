$LOAD_PATH << File.expand_path('..', __FILE__)

module Buckaroo
  module Ideal
    # The banks that are supported by Buckaroo's iDEAL platform
    BANKS = {
      ABNANL2A: "ABNAMRO Bank",
      ASNBNL21: "ASN Bank",
      FRBKNL2L: "Frieslandbank",
      INGBNL2A: "ING Bank",
      KNABNL2H: "Knab",
      RABONL2U: "Rabobank",
      RBRBNL21: "RegioBank",
      SNSBNL2A: "SNS Bank",
      TRIONL2U: "Triodos Bank",
      FVLBNL22: "Van Lanschot"
    }

    # The currencies that are supported by Buckaroo's iDEAL platform
    CURRENCIES = %w[ EUR ]

    # The languages supported by Buckaroo's user interface:
    LANGUAGES = %w[ NL EN DE FR ]

    autoload :VERSION,           'buckaroo-ideal/version'
    autoload :Config,            'buckaroo-ideal/config'
    autoload :Order,             'buckaroo-ideal/order'
    autoload :Response,          'buckaroo-ideal/response'
    autoload :Signature,         'buckaroo-ideal/signature'
    autoload :Request,           'buckaroo-ideal/request'
    autoload :Status,            'buckaroo-ideal/status'
    autoload :Util,              'buckaroo-ideal/util'
  end
end
