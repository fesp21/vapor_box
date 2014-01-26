class NotificationsMailer < ActionMailer::Base

  default :from => "ryeon@gmail.com"
  default :to => "shop@getvaporbox.com"

  def new_message(message)
    @message = message
    mail(:subject => "[YourWebsite.tld] #{message.subject}")
  end

end