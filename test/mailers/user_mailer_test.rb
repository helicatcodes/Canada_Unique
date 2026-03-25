require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "Registration" do
    mail = UserMailer.Registration
    assert_equal "Registration", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
