require 'stripe'

Stripe.api_key = "S5eZcyLrHDQM43WCbPoM95iPY1AXu6mm"

StripeEvent.setup do
  subscribe 'charge.succeeded' do |event|
    user = User.where(customer_id: event.data.object.customer).first
    amount = event.data.object.amount
    reference_id = event.data.object.id
    Payment.create(user: user, amount: amount, reference_id: reference_id)
  end

  subscribe 'charge.failed' do |event| 
    user = User.where(customer_id: event.data.object.customer).first
    user.deactivate! 
  end
end
