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

    class NotAcceptableError < BaseError
      def status
        406
      end
    end

    class UnsupportedMediaTypeError < BaseError
      def status
        415
      end
    end
  end
end
