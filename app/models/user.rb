require "redis"

class User < ApplicationRecord
  attr_accessor :redis_client

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

  def redis_client
    @redis_client = @redis_client || Redis.new
    @redis_client
  end

  def set_auth_key_redis

  end

end
