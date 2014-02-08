class NotificationsMailer < ActionMailer::Base

  default :from => "ryeon@gmail.com"
  default :to => "shop@getvaporbox.com"

  def new_message
    mail(:subject => "Test")
  end

end