class AdminNotification < ActionMailer::Base
  default from: "Carnet d'Adresses CI"

  def year_added(supadmins, user, last_registration, expires_at)
    @user = user
    @last_registration = last_registration
    @expires_at = expires_at

    mail(to: supadmins, subject: "Prolongation d'abonnement")
  end

  def enabling_disabling(supadmins, user, status)
    @user = user
    @status = status

    mail(to: supadmins, subject: "#{status ? 'Activation' : 'Désactivation'} de compte abonné")
  end


  def new_forum(supadmins, forum_theme)
    @forum_theme = forum_theme
    @supadmins = supadmins

    mail(to: supadmins, subject: "Création de thème de forum")
  end
end
