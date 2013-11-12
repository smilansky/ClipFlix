require 'spec_helper'

describe "Create payment on successful charge" do
  let(:event_data) do {
    "id" => "evt_2b1BL5hHkMoDDW",
    "created" => 1379526852,
    "livemode" => false,
    "type" => "charge.succeeded",
    "data" => {
      "object" => {
        "id" => "ch_2b1B6mUpw39bZK",
        "object" => "charge",
        "created" => 1379526852,
        "livemode" => false,
        "paid" => true,
        "amount" => 999,
        "currency" => "usd",
        "refunded" => false,
        "card" => {
          "id" => "card_2b1BaFzXyP3tah",
          "object" => "card",
          "last4" => "4242",
          "type" => "Visa",
          "exp_month" => 9,
          "exp_year" => 2013,
          "fingerprint" => "QmBJuLviOP1VUjZt",
          "customer" => "cus_2b1BGwu2rrrkkT",
          "country" => "US",
          "address_city" => nil,
          "cvc_check" => "pass"
        },
        "captured" => true,
        "balance_transaction" => "txn_2b1BTrwpTxCG0B",
        "failure_code" => nil,
        "customer" => "cus_2b1BGwu2rrrkkT",
        "invoice" => "in_2b1BsIgyrVVSue",
        "dispute" => nil,
        "fee" => 59,
        "fee_details" => [
          {
            "amount" => 59,
            "currency" => "usd",
            "type" => "stripe_fee",
            "description" => "Stripe processing fees",
            "application" => nil,
            "amount_refunded" => 0
          }
        ],
        "disputed" => false
      }
    },
    "object" => "event",
    "pending_webhooks" => 1,
    "request" => "iar_2b1B8DkxLob4p5"
  }
end
  it "creates a payment with the webhook from stripe for charge succeeded", :vcr do
    post '/stripe_events', event_data

    expect(Payment.count).to eq(1)
  end

  it "creates a payment associated with the user", :vcr do
    daniel = Fabricate(:user, customer_id: "cus_2b1BGwu2rrrkkT")

    post '/stripe_events', event_data
    expect(Payment.first.user).to eq(daniel)
  end

  it "creates the payment with the amount", :vcr do
    post '/stripe_events', event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates the payment with the reference id", :vcr do
    post '/stripe_events', event_data
    expect(Payment.first.reference_id).to eq("ch_2b1B6mUpw39bZK")
  end
end