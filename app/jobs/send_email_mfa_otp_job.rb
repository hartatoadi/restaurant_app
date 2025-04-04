class SendEmailMfaOtpJob
  include Sidekiq::Worker

  def perform(resource_id)
    resource = User.find(resource_id)
    UserMailer.with(user: resource).send_mfa_otp.deliver_now
  end
end
