class ContactMailer < ActionMailer::Base
  
  def contact_form(name, email, message)
    recipients 'tcorps@sunlightfoundation.com'
    from email
    subject "[T-Corps] Contact form submission from #{name}"
    body :message => message
  end

end