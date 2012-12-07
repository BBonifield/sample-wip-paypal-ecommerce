module OrdersControllerMacros

  def check_assigns_the_order method, use_params = nil
    use_params = required_params if use_params.nil?
    get method, use_params
    assigns(:order).should eq current_user_order
  end

  def check_response_success method, use_params = nil
    use_params = required_params if use_params.nil?
    get method, use_params
    response.should be_success
  end

  def check_for_already_finalized_redirect method, use_params = nil
    Order.any_instance.stub(:finalized?).and_return(true)
    get method, required_params
    response.should redirect_to root_path
    flash[:error].should eq "You cannot resubmit that order.  It has already been finalized"
  end

  def check_creation_and_assignment_of_purchase
    expect {
      get :purchase_process, required_params
    }.to change(Purchase, :count).by(1)

    # ensure that the assigned purchase is the newly created purchase
    assigns(:purchase).should eq Purchase.last

    # ensure that the purchase belongs to the order
    assigns(:purchase).order.should eq current_user_order

    # ensure that the proper urls were passed into the purchase as well
    return_url = purchase_complete_offer_order_url(current_user_offer, current_user_order)
    cancel_url = purchase_cancelled_offer_order_url(current_user_offer, current_user_order)
    ipn_notification_url = paypal_ipn_notification_url
    assigns(:purchase).return_url.should eq return_url
    assigns(:purchase).cancel_url.should eq cancel_url
    assigns(:purchase).ipn_notification_url.should eq ipn_notification_url
  end
end
