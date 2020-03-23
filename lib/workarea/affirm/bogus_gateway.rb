module Workarea
  module Affirm
    class BogusGateway
      def initialize(*); end

      def get_checkout(token)
        b = if token == 'total_error'
              get_checkout_response_total_error_body
            else
              get_checkout_response_body
            end
        Response.new(response(b))
      end

      def capture(_payment_id, _amount, _request_id)
        b = {
          "fee": 600,
          "created": '2016-03-18T00:03:44Z',
          "order_id": 'JKLM4321',
          "currency": 'USD',
          "amount": 6100,
          "type": 'capture',
          "id": 'O5DZHKL942503649',
          "transaction_id": '6dH0LrrgUaMD7Llc',
          "merchant_transaction_id": 'A2189192837'
        }

        Response.new(response(b, 200))
      end

      def authorize(_token, _order_id = '', _request_id)
        Response.new(response(payment_response_body, 200))
      end

      def purchase(_token, _order_id = '', _request_id)
        Response.new(response(payment_response_body, 200))
      end

      def refund(_affirm_order_id, _amount, _request_id)
        b = {
          "created": '2014-03-18T19:20:30Z',
          "fee_refunded": 1500,
          "amount": 50_000,
          "type": 'refund',
          "id": 'OWA49MWUCA29SBVQ',
          "transaction_id": 'r86zdkHONPcaiVJJ'
        }

        Response.new(response(b))
      end

      def void(_payment_id)
        Response.new(response(payment_response_body))
      end

      private

      def response(body, status = 200)
        response = Faraday.new do |builder|
          builder.adapter :test do |stub|
            stub.get('/v1/bogus') { |_env| [status, {}, body.to_json] }
          end
        end
        response.get('/v1/bogus')
      end

      def get_checkout_response_body
        {
          "api_version": 'v2',
          "billing": {
            "address": {
              "city": 'Philadelphia',
              "country": 'USA',
              "line1": '22 south 3rd street',
              "line2": '',
              "state": 'PA',
              "zipcode": '19063'
            },
            "email": 'jyucis@weblinc.com',
            "name": {
              "first": 'Jeffrey',
              "full": 'Jeffrey Yucis',
              "last": 'Yucis'
            },
            "phone_number": '+1-553-750-7743'
          },
          "checkout_flow_type": 'classic',
          "checkout_status": 'confirmed',
          "checkout_type": 'merchant',
          "config": {
            "user_confirmation_url_action": 'GET'
          },
          "currency": 'USD',
          "financing_program_external_name": 'standard_3_6_12',
          "financing_program_name": 'standard_3_6_12',
          "items": {
            "OBWH-01": {
              "display_name": 'Product 1',
              "item_image_url": '/product_images/placeholder/detail.jpg?c=1580497327',
              "item_type": 'physical',
              "item_url": 'http://www.example.com/products/w-h-smith-collection-t-shift',
              "qty": 1,
              "sku": 'SKU 1',
              "unit_price": 10_000
            }
          },
          "loan_type": 'classic',
          "merchant": {
            "name": 'Workarea',
            "public_api_key": 'CXIR9J2CJESHKXGJ',
            "user_cancel_url": 'http://localhost:3000/checkout/payment',
            "user_confirmation_url": 'http://localhost:3000/affirm/complete',
            "user_confirmation_url_action": 'GET'
          },
          "merchant_external_reference": 'DA76560945',
          "meta": {
            "__affirm_tracking_uuid": 'f0c19176-0eca-469e-bcec-b42bf46e2b41',
            "release": 'false',
            "user_timezone": 'America/New_York'
          },
          "metadata": {
            "checkout_channel_type": 'online'
          },
          "mfp_rule_input_data": {
            "items": {
              "OBWH-01": {
                "display_name": 'W H Smith Collection T-Shift',
                "item_image_url": '/product_images/placeholder/detail.jpg?c=1580497327',
                "item_type": 'physical',
                "item_url": 'http://www.example.com/products/w-h-smith-collection-t-shift',
                "qty": 1,
                "sku": 'OBWH-01',
                "unit_price": 10_000
              }
            },
            "metadata": {
              "checkout_channel_type": 'online'
            },
            "total": 10_600
          },
          "order_id": 'DA76560945',
          "product": 'checkout',
          "shipping_amount": 600,
          "tax_amount": 0,
          "total": 10_600
        }
      end

      def get_checkout_response_total_error_body
        {
          "api_version": 'v2',
          "billing": {
            "address": {
              "city": 'Philadelphia',
              "country": 'USA',
              "line1": '22 south 3rd street',
              "line2": '',
              "state": 'PA',
              "zipcode": '19063'
            },
            "email": 'jyucis@weblinc.com',
            "name": {
              "first": 'Jeffrey',
              "full": 'Jeffrey Yucis',
              "last": 'Yucis'
            },
            "phone_number": '+1-553-750-7743'
          },
          "checkout_flow_type": 'classic',
          "checkout_status": 'confirmed',
          "checkout_type": 'merchant',
          "config": {
            "user_confirmation_url_action": 'GET'
          },
          "currency": 'USD',
          "financing_program_external_name": 'standard_3_6_12',
          "financing_program_name": 'standard_3_6_12',
          "items": {
            "OBWH-01": {
              "display_name": 'Product 1',
              "item_image_url": '/product_images/placeholder/detail.jpg?c=1580497327',
              "item_type": 'physical',
              "item_url": 'http://www.example.com/products/w-h-smith-collection-t-shift',
              "qty": 1,
              "sku": 'SKU 1',
              "unit_price": 10_000
            }
          },
          "loan_type": 'classic',
          "merchant": {
            "name": 'Workarea',
            "public_api_key": 'CXIR9J2CJESHKXGJ',
            "user_cancel_url": 'http://localhost:3000/checkout/payment',
            "user_confirmation_url": 'http://localhost:3000/affirm/complete',
            "user_confirmation_url_action": 'GET'
          },
          "merchant_external_reference": 'DA76560945',
          "meta": {
            "__affirm_tracking_uuid": 'f0c19176-0eca-469e-bcec-b42bf46e2b41',
            "release": 'false',
            "user_timezone": 'America/New_York'
          },
          "metadata": {
            "checkout_channel_type": 'online'
          },
          "mfp_rule_input_data": {
            "items": {
              "OBWH-01": {
                "display_name": 'W H Smith Collection T-Shift',
                "item_image_url": '/product_images/placeholder/detail.jpg?c=1580497327',
                "item_type": 'physical',
                "item_url": 'http://www.example.com/products/w-h-smith-collection-t-shift',
                "qty": 1,
                "sku": 'OBWH-01',
                "unit_price": 10_000
              }
            },
            "metadata": {
              "checkout_channel_type": 'online'
            },
            "total": 10_600
          },
          "order_id": 'DA76560945',
          "product": 'checkout',
          "shipping_amount": 600,
          "tax_amount": 0,
          "total": 1
        }
      end

      def capture_error_response_body
        {
          "errorCode": 'declined',
          "errorId": 'c4d64cbc3e61a26f',
          "message": 'Payment declined',
          "httpStatusCode": 402
        }
      end

      def payment_response_body
        {
          "id": 'ALO4-UVGR',
          "created": '2016-03-18T19:19:04Z',
          "currency": 'USD',
          "amount": 6100,
          "auth_hold": 6100,
          "payable": 0,
          "void": false,
          "expires": '2016-04-18T19:19:04Z',
          "order_id": 'JKLM4321',
          "events": [
            {
              "created": '2014-03-20T14:00:33Z',
              "currency": 'USD',
              "id": 'UI1ZOXSXQ44QUXQL',
              "transaction_id": 'TpR3Xrx8TkvuGio0',
              "type": 'auth'
            }
          ],
          "details": {
            "items": {
              "sweater-a92123": {
                "sku": 'sweater-a92123',
                "display_name": 'Sweater',
                "qty": 1,
                "item_type": 'physical',
                "item_image_url": 'http://placehold.it/350x150',
                "item_url": 'http://placehold.it/350x150',
                "unit_price": 5000
              }
            },
            "order_id": 'JKLM4321',
            "shipping_amount": 400,
            "tax_amount": 700,
            "shipping": {
              "name": {
                "full": 'John Doe'
              },
              "address": {
                "line1": '325 Pacific Ave',
                "city": 'San Francisco',
                "state": 'CA',
                "zipcode": '94112',
                "country": 'USA'
              }
            },
            "discounts": {
              "RETURN5": {
                "discount_amount": 500,
                "discount_display_name": 'Returning customer 5% discount'
              },
              "PRESDAY10": {
                "discount_amount": 1000,
                "discount_display_name": "President's Day 10% off"
              }
            }
          }
        }
      end
    end
  end
end
