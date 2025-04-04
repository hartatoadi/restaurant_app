class Users::SessionsController <  Devise::SessionsController
  def create
    super do |resource|
      if resource.mfa_verified == false
        resource.generate_mfa_secret
        redirect_to verify_mfa_path
        return
      end
    end
  end
end
