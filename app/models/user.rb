class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :full_name, :role, :email, :password, :password_confirmation, :remember_me

  before_validation :check_role

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
