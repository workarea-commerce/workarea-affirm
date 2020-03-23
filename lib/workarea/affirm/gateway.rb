module Workarea
  module Affirm
    class Gateway
      attr_reader :public_key, :private_key, :test

      def initialize(options = {})
        @public_key = options[:public_key]
        @private_key = options[:private_key]
        @test = options[:test]
      end

      def get_checkout(token)
          response = connection.get do |req|
          req.url "/api/v2/checkout/#{token}"
        end

        Affirm::Response.new(response)
      end

      def authorize(token, order_id)
        body = {
          checkout_token: token,
          order_id: order_id
        }
        response = connection.post do |req|
          req.url "/api/v2/charges"
          req.body = body.to_json
        end

        Affirm::Response.new(response)
      end

      def capture(charge_id, amount, order_id)
        body = {
          amount:  amount.cents,
          order_id: order_id
        }
        response = connection.post do |req|
          req.url "api/v2/charges/#{charge_id}/capture"
          req.body = body.to_json
        end

        Affirm::Response.new(response)
      end

      def refund(charge_id, amount)
        body = {
          amount:  amount.cents,
          type: "refund"
        }

        response = connection.post do |req|
          req.url "/api/v2/charges/#{charge_id}/refund"
          req.body = body.to_json
        end

        Affirm::Response.new(response)
      end

      def void(charge_id)
        response = connection.post do |req|
          req.url "/api/v2/charges/#{charge_id}/void"
        end

        Affirm::Response.new(response)
      end

      private

      def connection
        headers = {
          "Content-Type" => "application/json",
          "Accept"       => "application/json",
          "Authorization" => "Basic #{encoded_credentials}",
        }

        request_timeouts = {
          timeout: Workarea.config.affirm[:api_timeout],
          open_timeout: Workarea.config.affirm[:open_timeout]
        }

        conn = Faraday.new(url: rest_endpoint, headers: headers, request: request_timeouts)
        conn.basic_auth(public_key, private_key)
        conn
      end

      def encoded_credentials
        Base64.encode64("#{public_key}:#{private_key}") \
          .gsub(/\n/, '').strip
      end

      def test?
        test
      end

      def rest_endpoint
        if test?
          "https://sandbox.affirm.com"
        else
          "https://api.affirm.com"
        end
      end
    end
  end
end
