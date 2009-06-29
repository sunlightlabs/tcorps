class ContactMailer < ActionMailer::Base
  
  def contact_form(name, email, message)
    recipients 'tcorps@sunlightfoundation.com'
    from 'tcorps@sunlightfoundation.com'
    subject "[T-Corps] Contact form submission from #{name}"
    body :name => name, :email => email, :message => message
  end

end