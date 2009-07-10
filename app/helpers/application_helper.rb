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
  
  def to_word(number)
    {
      1 => 'One',
      2 => 'Two',
      3 => 'Three',
      4 => 'Four',
      5 => 'Five',
      6 => 'Six',
      7 => 'Seven',
      8 => 'Eight',
      9 => 'Nine',
      10 => 'Ten'
    }[number] || number
  end
  
  def to_minutes(seconds)
    "#{seconds / 60}:#{seconds % 60}"
  end
end