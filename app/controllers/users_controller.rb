class UsersController < ApplicationController
  def verify_mfa
  end

  def verify_mfa_submit
    user = current_user
    otp = params[:otp]

    if user.verify_mfa(otp)
      user.update(mfa_verified: true)
      redirect_to root_path, notice: 'MFA verified successfully'
    else
      flash.now[:alert] = 'Invalid OTP'
      render :verify_mfa
    end
  end
end
