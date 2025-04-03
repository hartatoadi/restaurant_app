class UserMailer < ApplicationMailer
  def send_mfa_otp
    @user = params[:user]
    @otp = ROTP::TOTP.new(@user.mfa_secret).now
    mail(to: @user.email, subject: 'Your MFA Code')
  end
end
