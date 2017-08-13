class NotificationsMailer < ApplicationMailer
  def new_user(user, default_password)
    @user = user
    @default_password = default_password

    email_with_name = %("#{@user.name}" <#{@user.email}>)
    mail to: email_with_name, subject: "New User Account: #{@user.name} (#{@user.email})"
  end
end
