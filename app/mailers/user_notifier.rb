class UserNotifier < ApplicationMailer

  default :from => 'cmusocius@gmail.com'

  # send a notification that a post has been created
  def send_post_notification(post)
    @post = post
    recipients = @post.notify_emails
    puts("Here is the recipients")
    puts(recipients)
    if recipients != ""
    mail(:to => recipients, :subject => 'New Request at ' + post.street_1)
    end
  end

  def claim_notification(post,claimer)
    @claimer = claimer
    @post = post
    @poster = post.poster
    @post_needs = @post.post_needs.alphabetical
    if @poster.can_notify?
       mail(:to => @poster.email, :subject => claimer.proper_name+" claimed your request at "+ post.street_1)
    end
  end

  def comment_notification(post,comment)
    @post = post
    @poster = post.poster
    @comment = comment
    recipients = @post.claimers.can_notify.collect(&:email).join(',')
    if @poster.can_notify? and !@post.is_claimer?(@poster)
      recipients = recipients+","+@poster.email
    end
    # @post.comments.each do |c|
    #   if c.user.can_notify? and !@post.is_claimer?(c.user) and !c.user_id == @poster.id
    #     puts("get in here")
    #     puts(c.user.email)
    #     recipients = recipients+","+c.user.email
    #   end
    # end
    if recipients != ""
       mail(:to => recipients, :subject => "A New Comment for post at "+ @post.street_1)
    end
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
