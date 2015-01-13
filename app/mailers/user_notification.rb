class UserNotification < ActionMailer::Base
  default from: "Carnet d'Adresses CI"

  def year_added(user, last_registration, expires_at)
    @user = user
    @last_registration = last_registration
    @expires_at = expires_at

    mail(to: @user.email, subject: "Prolongation d'abonnement")
  end

  def enabling_disabling(user, status)
    @user = user
    @status = status

    mail(to: @user.email, subject: "#{status ? 'Activation' : 'Désactivation'} de votre compte")
  end
end
