module Square
  module Connect
    module Connections
      module Payments
        # Example usage:
        #   connection.payments(limit: 200) do |payment|
        #     ... 
        #   end
        #
        def payments(params = { }, &block)
          access_token_required!

          response = nil
          payments = handle_response do
            access_token.get endpoint_for(identifier, :payments), params
          end

          payments.each do |payment|
            yield Payment.new(payment.merge(access_token: access_token))
          end

          if response.headers[:link].to_s.include?("rel='next'")
            payments(params.merge! batch_token: response.headers[:link].
                                            split('?batch_token=').last.
                                            split('>').first, &block)
          end
        end

        def payment(payment_id, params = nil)
          access_token_required!
          Payment.new(
            payment_id,
            merchant_id: identifier,
            access_token: access_token
          ).fetch
        end
      end
    end
  end
end







