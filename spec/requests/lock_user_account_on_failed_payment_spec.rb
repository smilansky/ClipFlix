require 'spec_helper'

describe "Lock user account on failed charge" do
  let(:event_data) do {
  "id" => "evt_2uGLhnStsvm90H",
  "created" => 1383965386,
  "livemode" => false,
  "type" => "charge.failed",
  "data" => {
    "object" => {
      "id" => "ch_2uGLrY2XqZzoWi",
      "object" => "charge",
      "created" => 1383965386,
      "livemode" => false,
      "paid" => false,
      "amount" => 999,
      "currency" => "usd",
      "refunded" => false,
      "card" => {
        "id" => "card_2uGKU4c9NKsGVo",
        "object" => "card",
        "last4" => "0341",
        "type" => "Visa",
        "exp_month" => 11,
        "exp_year" => 2014,
        "fingerprint" => "k5FwZPGIRnT053Hw",
        "customer" => "cus_2uDDXHCreUbyU1",
        "country" => "US",
        "address_city" => nil,
        "cvc_check" => "pass"
      },
      "captured" => false,
      "balance_transaction" => nil,
      "failure_message" => "Your card was declined.",
      "failure_code" => "card_declined",
      "customer" => "cus_2uDDXHCreUbyU1",
      "description" => "failed payment",
      "dispute" => nil,
      "metadata" => {},
      "fee" => 0,
      "fee_details" => [],
      "disputed" => false
    }
  },
  "object" => "event",
  "pending_webhooks" => 2,
  "request" => "iar_2uGLe3CTJPkoeD"
}
end
  it "locks the user's account with the webhook from stripe for charge failed", :vcr do
    daniel = Fabricate(:user, customer_id: "cus_2uDDXHCreUbyU1")
    post '/stripe_events', event_data 

    expect(daniel.reload).not_to be_active
  end
end