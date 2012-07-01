class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :full_name, :role, :email, :password, :password_confirmation, :remember_me, :login

  validates_uniqueness_of :username
  validates :username, :presence => true

  attr_accessor :login

  before_validation :check_role


  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def self.find_for_authentication(conditions)
    login = conditions.delete(:login)
    where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login }]).first
  end


  # Posible roles for users
  def self.roles
    [['User', 'user'], ['Administrator', 'admin'], ['Operator', 'op']]
  end

  def self.admin_count
    self.where(:role => 'admin').size
  end

  def self.op_count
    self.where(:role => 'op').size
  end

  def self.user_count
    self.where(:role => 'user').size
  end

  def check_role
    if self.role.nil?
      self.role = 'user'
    end
  end
end
