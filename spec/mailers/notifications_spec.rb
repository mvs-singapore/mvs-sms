require "rails_helper"

RSpec.describe NotificationsMailer, type: :mailer do
  describe ".new_user" do
    let!(:default_password) { User.generate_random_password }
    let!(:user) { User.create(email: 'teacher@example.com', password: default_password, name: 'Teacher Yammy', role: 'teacher') }
    let(:mail) { NotificationsMailer.new_user(user, default_password) }

    it "renders the headers" do
      expect(mail.subject).to eq("New User Account: #{user.name} (#{user.email})")
      expect(mail.to).to eq(["teacher@example.com"])
      expect(mail.from).to eq(["sms-admin@mvs.edu.sg"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include "Welcome #{user.name}, to MVS-Student Management System"
      expect(mail.body.encoded).to include default_password
    end
  end

end
