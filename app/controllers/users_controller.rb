class UsersController < ApplicationController
  def verify_mfa
  end

  def verify_mfa_submit
    user = current_user
    otp = params[:otp]

    if user.verify_mfa(otp)
      user.update(mfa_verified: true)
      if params[:remember_device] == "1"
        cookies.signed[:mfa_verified] = {
          value: true,
          expires: 30.days.from_now
        }
      end
      sign_in current_user
      redirect_to root_path, notice: 'MFA verified successfully'
    else
      flash.now[:alert] = 'Invalid OTP'
      render :verify_mfa
    end
  end
end
