class StaticPageController < ApplicationController
  def root
    render :static
  end

  def send_mail
    applications = Application.all
    applications.each do |app|
      ApplicationMailer.application_email(app).deliver_now
    end
    @applications = applications.select(
      :company,
      :position,
      :url,
      :email
    )
    render :javascript_code
  end
end
