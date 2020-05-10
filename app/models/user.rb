class User < ApplicationRecord
  attr_accessor :redis_client

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attribute :name, :string
  attribute :email, :string
  attribute :is_admin, :boolean

  def auth_payload
    s = serialize
    s[:auth_token] = JsonWebToken.encode({ user_id: id })
    s
  end

  def serialize
    {
      id: id,
      email: email,
      is_admin: is_admin,
    }
  end

end
