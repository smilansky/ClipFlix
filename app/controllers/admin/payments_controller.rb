class Admin::PaymentsController < ApplicationController

  before_filter :require_user
  before_filter :require_admin, only: :index

  def index
    @payments = Payment.all
  end

  def create

StripeEvent.setup do
  subscribe 'charge.failed' do |event|
    # Define subscriber behavior based on the event object
    event.class #=> Stripe::Event
    event.type  #=> "charge.failed"
    event.data  #=> { ... }
  end

  subscribe 'customer.created', 'customer.updated' do |event|
    # Handle multiple event types
  end

  subscribe do |event|
    # Handle all event types - logging, etc.
  end
end


  end
end