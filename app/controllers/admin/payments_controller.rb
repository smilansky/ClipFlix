class Admin::PaymentsController < ApplicationController

  before_filter :require_user
  before_filter :require_admin, only: :index

  def index
    @payments = Payment.all
  end
end