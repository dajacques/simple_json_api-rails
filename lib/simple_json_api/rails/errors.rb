module SimpleJsonApi
  module Rails
    class Error < StandardError
      def status
        500
      end
    end

    class BadRequestError < Error
      def status
        400
      end
    end

    class NotFoundError < Error
      def status
        404
      end
    end

    class NotAcceptableError < Error
      def status
        406
      end
    end

    class ConflictError < Error
      def status
        409
      end
    end

    class UnsupportedMediaTypeError < Error
      def status
        415
      end
    end
  end
end
