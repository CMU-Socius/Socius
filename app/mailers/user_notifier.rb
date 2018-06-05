class UserNotifier < ApplicationMailer

  default :from => 'cmusocius@gmail.com'

  # send a notification that a post has been created
  def send_post_notification(post)
    @post = post
    @poster = post.poster
    @post_needs = @post.post_needs.alphabetical
    org = Organization.find(@poster.organization_id)
    recipients = org.users.can_notify.collect(&:email).join(',')
    mail(:to => recipients, :subject => 'New Request at ' + post.street_1)
  end

  def new_account_notification(user)
    @user = user
    admins = User.admin
    recipients = admins.collect(&:email).join(',')
    mail(:to => recipients, :subject => 'New Account Created')
  end

  def approved_notification(user)
    @user = user
    mail(:to => @user.email, :subject => 'Your Socius Account is approved ')
  end

end
