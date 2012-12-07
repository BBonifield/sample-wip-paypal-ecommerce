class PaypalAdaptive::FakeResponse
  def initialize h={}
    @success = h[:success]

    # initialize a payKey here so ['payKey'] always returns
    # the same value
    @payKey = 'AP-' + Faker::Lorem.characters(10) if success?
  end

  def success?
    @success
  end

  def errors
    if success?
      []
    else
      [{'message' => 'Fake error message'}]
    end
  end

  def approve_paypal_payment_url type=nil
    if success?
      'http://fake.domain.com/path/to/payment'
    end
  end

  def [] key
    if key == 'payKey'
      if success?
        @payKey
      end
    end
  end
end


def stub_paypal_adaptive_with_successful_response
  mock_response = PaypalAdaptive::FakeResponse.new :success => true
  stub_paypal_adaptive_pay_with_response mock_response
end

def stub_paypal_adaptive_with_failed_response
  mock_response = PaypalAdaptive::FakeResponse.new :success => false
  stub_paypal_adaptive_pay_with_response mock_response
end

def stub_paypal_adaptive_pay_with_response response
  PaypalAdaptive::Request.any_instance.
    stub(:pay).
    and_return(response)
end


def stub_paypal_adaptive_notification_as_verified
  PaypalAdaptive::IpnNotification.any_instance.stub(:verified?).and_return(true)
end

def stub_paypal_adaptive_notification_as_unverified
  PaypalAdaptive::IpnNotification.any_instance.stub(:verified?).and_return(false)
end


# Stub out the pay requests and notification checks by default to prevent
# system from hitting paypal unless we want to
RSpec.configure do |config|
  config.before do
    stub_paypal_adaptive_with_successful_response
    stub_paypal_adaptive_notification_as_verified
  end
end
