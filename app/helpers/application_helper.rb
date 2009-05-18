module ApplicationHelper
  def is_home?(body_class)
    [nil, :home].include? body_class
  end
  
  def errors(object)
    render :partial => 'layouts/errors', :locals => {:object => object}
  end
end