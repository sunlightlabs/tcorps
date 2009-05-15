class ContactMailer < ActionMailer::Base
  
  def contact_form(name, email, message)
    recipients 'tcorps@sunlightlabs.com'
    from 'tcorps@sunlightlabs.com'
    subject "Contact form submission from #{name}"
    body :name => name, :email => email, :message => message
  end

end