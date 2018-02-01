class StaticPageController < ApplicationController
  def root
    render :static
  end

  def send_mail
    applications = Application.where('sent is false').take(10)
    sent = []
    begin 
      applications.each do |app|
        ApplicationMailer.application_email(app).deliver_now
        app.update(sent: true)
        sent << app
      end
    rescue Exception => msg  
      puts " SOMETHING BROKE: " + msg.to_s
    ensure
      @applications = sent.map! { |app| app.slice( :company, :position, :url, :email, :source ) }
      render :javascript_code
    end
  end
end
