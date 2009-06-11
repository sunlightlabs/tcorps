module ApplicationHelper
  def is_home?(body_class)
    [nil, :home].include? body_class
  end
  
  def errors(object)
    render :partial => 'layouts/partials/errors', :locals => {:object => object}
  end
  
  def period(string)
    string << (string.last == '.' ? '' : '.')
  end
end