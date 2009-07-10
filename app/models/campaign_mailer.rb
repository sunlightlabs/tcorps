class CampaignMailer < ActionMailer::Base
  
  def new_campaign(campaign, user)
    recipients user.email
    from 'tcorps@sunlightfoundation.com'
    subject "A new campaign has appeared on TransparencyCorps"
    body :campaign => campaign, :user => user, :host => SITE_HOST
    content_type 'text/html'
  end
end
