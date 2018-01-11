class ApplicationMailer < ActionMailer::Base
  default from: 'jcompagni@gmail.com'

  def application_email(app)
    @position = app.position
    @company = app.company
    @contact_name = app.contact_name
    mail(to: app.email, subject: app.position)
  end

end
