class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.Registration.subject
  #
  def Registration(user)
    @user = user
    @greeting = "Hi #{@user.name}"

    mail to: @user.email
  end

  def invitation(email,token)
    @url = verify_invitation_url(token: token.token)
    mail to: email, subject:"Your invitation to Canada Unique"
  end
end
