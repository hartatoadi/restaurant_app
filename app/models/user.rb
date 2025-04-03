class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def generate_mfa_secret
    self.mfa_secret = ROTP::Base32.random
    save!
  end

  def verify_mfa(otp)
    totp = ROTP::TOTP.new(mfa_secret)
    totp.verify(otp)
  end
end
