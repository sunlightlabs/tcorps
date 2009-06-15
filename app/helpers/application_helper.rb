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
  
  def open_id_return?
    params[:open_id_complete] == '1'
  end
end