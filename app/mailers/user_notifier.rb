class UserNotifier < ApplicationMailer

  default :from => 'seanpark1107@gmail.com'

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_post_notification(post)
    @post = post
    mail( :to => 'seanpark1107@gmail.com',
    :subject => 'New Request at ' + post.street_1 )
  end

end
