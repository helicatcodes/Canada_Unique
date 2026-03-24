# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/Registration
  def invitation
    token = Token.first || Token.create!(email: "test@example.com", token: SecureRandom.urlsafe_base64, status: "pending")
    UserMailer.invitation(token.email, token)
  end
end
