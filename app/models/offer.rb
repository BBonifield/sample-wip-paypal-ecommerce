class Offer < ActiveRecord::Base
  STATE_PENDING = 'pending'
  STATE_DECLINED = 'declined'
  STATE_ACCEPTED = 'accepted'

  # mass assignment
  attr_accessible :inventory_item_id,
    :price


  # associations
  has_one :order,
    :dependent => :nullify
  belongs_to :posting
  belongs_to :inventory_item


  # validations
  validates_presence_of :posting,
    :inventory_item
  validates_inclusion_of :state,
    :in => [ STATE_PENDING, STATE_DECLINED, STATE_ACCEPTED ]
  validates_numericality_of :price,
    :greater_than => 0


  # state transition
  def accept
    if self.state == STATE_PENDING
      update_state STATE_ACCEPTED

      decline_other_offers_on_posting
      remove_inventory_from_available_stock
      remove_posting_from_active_postings
    end
  end

  def decline
    if self.state == STATE_PENDING
      update_state STATE_DECLINED
    end
  end

  def unaccept
    if self.state == STATE_ACCEPTED
      update_state STATE_PENDING

      undecline_other_offers_on_posting
      add_inventory_to_available_stock
      add_posting_to_active_postings
    end
  end

  def undecline
    if self.state == STATE_DECLINED
      update_state STATE_PENDING
    end
  end


  private


  def update_state new_state
    self.state = new_state
    save
  end

  def decline_other_offers_on_posting
    Offer.where("posting_id = ? AND id != ?", self.posting_id, self.id).each do |offer|
      offer.decline
    end
  end

  def undecline_other_offers_on_posting
    Offer.where("posting_id = ? AND id != ?", self.posting_id, self.id).each do |offer|
      offer.undecline
    end
  end

  def remove_inventory_from_available_stock
    inventory_item.decrement_quantity
  end

  def add_inventory_to_available_stock
    inventory_item.increment_quantity
  end

  def remove_posting_from_active_postings
    posting.purchase_pending
  end

  def add_posting_to_active_postings
    posting.purchase_cancelled
  end
end
