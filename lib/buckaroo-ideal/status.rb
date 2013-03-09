module Buckaroo
  module Ideal
    class Status
      class UnknownStatusCode < StandardError; end

      STATES = {
        :completed => %w(190),
        :pending   => %w(790 791 792 793),
        :failed    => %w(490 491 492 690 890 891)
      }
      STATUS_CODES = {}
      STATUS_CODES["190"] = "Payment success"
      STATUS_CODES["490"] = "Payment failure"
      STATUS_CODES["491"] = "Validation error"
      STATUS_CODES["492"] = "Technical error"
      STATUS_CODES["690"] = "Payment rejected"
      STATUS_CODES["790"] = "Waiting for user input"
      STATUS_CODES["791"] = "Waiting for processor"
      STATUS_CODES["792"] = "Waiting on consumer action (e.g.: initiate money transfer)"
      STATUS_CODES["793"] = "Payment on hold (e.g. waiting for sufficient balance)"
      STATUS_CODES["890"] = "Cancelled by consumer"
      STATUS_CODES["891"] = "Cancelled by merchant"

      attr_reader :code, :message



      def initialize(code)
        if message = STATUS_CODES[code]
          @code    = code
          @message = message
        else
          raise UnknownStatusCode
        end
      end

      def state
        STATES.each do |state, codes|
          return state if codes.include? @code
        end

        :unknown
      end

      def completed?; state == :completed; end
      def pending?;   state == :pending;   end
      def failed?;    state == :failed;    end

      def ==(other)
        other.respond_to?(:code) && other.code == code
      end
    end
  end
end
