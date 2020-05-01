class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attribute :name, :string
  attribute :email, :string

  def auth_payload
    s = serialize
    s[:auth_token] = JsonWebToken.encode({ user_id: id })
    s
  end

  def serialize
    {
      id: id,
      email: email,
    }
  end

end
