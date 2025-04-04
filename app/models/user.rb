class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  #Callbacks
  after_commit :send_email_mfa_otp, if: Proc.new { self.saved_change_to_mfa_secret? }, on: :update

  def generate_mfa_secret
    self.mfa_secret = ROTP::Base32.random
    save!
  end

  def verify_mfa(otp)
    totp = ROTP::TOTP.new(mfa_secret)
    totp.verify(otp)
  end

  private
  def send_email_mfa_otp
    SendEmailMfaOtpJob.perform_async(self.id)
  end
end
