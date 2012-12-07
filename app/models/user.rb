class User < ActiveRecord::Base
  authenticates_with_sorcery!

  # flag to indicate whether or not the user is signing up
  attr_accessor :is_signing_up


  # mass assignment
  attr_accessible :user_name,
    :email,
    :password,
    :password_confirmation,
    :first_name,
    :last_name,
    :addresses_attributes


  # associations
  has_many :addresses,
    :dependent => :destroy,
    :inverse_of => :user
  accepts_nested_attributes_for :addresses,
    :limit => 1
  has_many :inventory_items,
    :dependent => :destroy
  has_many :postings,
    :dependent => :destroy
  has_many :inventory_groups,
    :dependent => :destroy


  # validations
  validates :user_name,
    :presence => true,
    :uniqueness => true
  validates :email,
    :presence => true,
    :uniqueness => true
  validates_presence_of :first_name,
    :last_name

  validates_presence_of :password, :on => :create
  validates_confirmation_of :password, :if => :password

  validate :validate_require_nested_address, :if => :is_signing_up


  # concatenate first and last name together
  def full_name
    "#{first_name} #{last_name}"
  end


  private


  def validate_require_nested_address
    unless addresses.length == 1
      errors.add :base, "You must include an address during signup."
    end
  end
end
