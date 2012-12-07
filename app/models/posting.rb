class Posting < ActiveRecord::Base
  STATE_ACTIVE = 'active'
  STATE_PURCHASE_PENDING = 'purchase_pending'
  STATE_PURCHASE_COMPLETE = 'purchase_complete'

  mount_uploader :posting_image, ImageUploader

  # mass assignment
  attr_accessible :category_id,
    :condition_id,
    :details,
    :name,
    :price,
    :posting_image,
    :posting_image_cache


  # associations
  belongs_to :user
  belongs_to :condition
  belongs_to :category
  has_many :offers,
    :dependent => :destroy


  def self.valid_states
    [ STATE_ACTIVE, STATE_PURCHASE_PENDING, STATE_PURCHASE_COMPLETE ]
  end

  # validations
  validates_presence_of :user,
    :condition,
    :category
  validates_presence_of :name,
    :details,
    :posting_image
  validates_numericality_of :price,
    :greater_than => 0
  validates_inclusion_of :state,
    :in => valid_states


  def template_from_posting template_posting
    copy_fields = %w{category_id condition_id details name price}

    copy_fields.each do |field|
      assign_method = "#{field}=".to_sym
      read_method = field.to_sym
      self.send(assign_method, template_posting.send(read_method))
    end
  end


  # state transition
  def purchase_pending
    update_state STATE_PURCHASE_PENDING if self.state == STATE_ACTIVE
  end

  def purchase_complete
    update_state STATE_PURCHASE_COMPLETE if self.state == STATE_PURCHASE_PENDING
  end

  def purchase_cancelled
    update_state STATE_ACTIVE if self.state == STATE_PURCHASE_PENDING
  end


  private


  def update_state new_state
    self.state = new_state
    self.save
  end

end
