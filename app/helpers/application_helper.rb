module ApplicationHelper
  def is_home?(body_class)
    [nil, :home].include? body_class
  end
end