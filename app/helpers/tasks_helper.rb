module TasksHelper

  def task_url(task, user)
    options = {
      :username => user.login,
      :task_key => task.key,
      :points => user.campaign_points(task.campaign)
    }
    "#{task.campaign.url}?#{query_string_for options}"
  end
  
  def query_string_for(options = {})
    string = ""
    options.keys.each do |key|
      string << "&" unless key == options.keys.first
      string << "#{key}=#{CGI::escape options[key].to_s}"
    end
    string
  end

end