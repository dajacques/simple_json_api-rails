module SimpleJsonApi
  module Rails
    class BaseError < StandardError
      def status
        500
      end
    end

    class NotFoundError < BaseError
      def status
        404
      end
    end
  end
end
