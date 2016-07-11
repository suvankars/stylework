class UserMailer < ApplicationMailer
  default from: 'suvankar.17@gmail.com'
 
  def welcome_email(user)
    @user = user
    @url  = 'http://example.com/login'
    mail(to: @user[:email], subject: 'Welcome to My Awesome Site')
  end

  def reservation_email(user, start_time, end_time, address, price)
    #Can we do something better then sending a tons a variable???
    @user, @start_time, @end_time, @address, @price = user, start_time, end_time, address, price
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end
end

