class Order < ActiveRecord::Base
  STATE_NEW = 'new'

  STATE_PURCHASE_FAILED = 'purchase_failed'
  STATE_PURCHASE_ABANDONED = 'purchase_abandoned'
  STATE_PURCHASE_CANCELLED = 'purchase_cancelled'

  STATE_PURCHASE_COMPLETE = 'purchase_complete'
  STATE_SHIPPED = 'shipped'

  ABANDONMENT_MINUTE_THRESHOLD = 5


  # attributes
  attr_accessor :terms_and_conditions


  # mass assignment
  attr_accessible :shipping_address_id,
    :terms_and_conditions


  # associations
  belongs_to :offer
  belongs_to :shipping_address, :class_name => "Address"
  has_one :purchase, :dependent => :nullify


  # validations
  validates_presence_of :offer,
    :shipping_address

  validates :terms_and_conditions,
    :presence => true,
    :format => { :with => /1/, :message => 'must be agreed to' },
    :on => :create

  def self.valid_states
    [ STATE_NEW, STATE_PURCHASE_FAILED, STATE_PURCHASE_ABANDONED,
      STATE_PURCHASE_CANCELLED, STATE_PURCHASE_COMPLETE, STATE_SHIPPED ]
  end
  validates_inclusion_of :state,
    :in => valid_states


  # callbacks
  # @todo Move to an observer
  after_create :enqueue_abandonment_checker


  # helper to lookup order buyer
  def buyer
    # the user posting the request
    offer.posting.user
  end

  # helper to lookup order seller
  def seller
    # the user owning the inventory
    offer.inventory_item.user
  end


  # state transition
  def purchase_failed
    if state == STATE_NEW
      update_state STATE_PURCHASE_FAILED
      unaccept_offer
    end
  end

  def purchase_abandoned
    if state == STATE_NEW
      update_state STATE_PURCHASE_ABANDONED
      unaccept_offer
    end
  end

  def purchase_cancelled
    if state == STATE_NEW
      update_state STATE_PURCHASE_CANCELLED
      unaccept_offer
    end
  end

  def purchase_complete
    if state == STATE_NEW
      update_state STATE_PURCHASE_COMPLETE
      finalize_remove_posting_from_active_postings
    end
  end

  def shipped
    if state == STATE_PURCHASE_COMPLETE
      update_state STATE_SHIPPED
    end
  end


  # a helper method to check if an order is finalized
  # by examining it's state
  def finalized?
    self.state != STATE_NEW
  end


  private


  def enqueue_abandonment_checker
    Resque.enqueue_in(ABANDONMENT_MINUTE_THRESHOLD.minutes, AbandonedOrderChecker, self.id)
  end

  def update_state new_state
    self.state = new_state
    save
  end

  def unaccept_offer
    self.offer.unaccept
  end

  def finalize_remove_posting_from_active_postings
    offer.posting.purchase_complete
  end
end
