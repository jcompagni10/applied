class ApplicationMailer < ActionMailer::Base
  default from: 'jcompagni@gmail.com'

  def application_email(app)
    @position = app.position
    @company = app.company
    @contact_name = app.contact_name
    cover_letter = pdf = WickedPdf.new.pdf_from_string(
      # render_to_string('app/views/cover_letters/default.html', layout: false)
      render 'cover_letters/standard', layout: false, locals: {app: app}
    )

    mail.attachments['julian_compagni_portis_resume.pdf'] = File.read('app/assets/images/julian_compagni_portis_resume.pdf')
    mail.attachments['Julian_compagni_portis_cover_letter.pdf'] = cover_letter
    mail(to: app.email, subject: app.position)
  end

end


