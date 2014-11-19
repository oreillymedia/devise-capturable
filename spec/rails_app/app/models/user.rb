class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :capturable, :database_authenticatable, :rememberable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessor :access_token
  # attr_accessible :title, :body

  validates :janrain_uuid, presence: true, uniqueness: true

  def before_capturable_create(capture_data, params)
    self.janrain_uuid = capture_data["uuid"]
    set_attributes_from_capture(capture_data)
  end

  def before_capturable_sign_in(capture_data, params)
    set_attributes_from_capture(capture_data)
    self.save!
  end

  def self.find_with_capturable_params(capture_data)
    self.find_by_janrain_uuid(capture_data["uuid"])
  end

  private

  def set_attributes_from_capture(capture_data)
    self.email = capture_data["email"]
  end
end
