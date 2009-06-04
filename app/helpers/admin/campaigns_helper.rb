module Admin::CampaignsHelper

  # 'capture' and 'concat' are two helpers in ActionView to work with ERB
  def if_javascript(&block)
    if block_given?
      content = capture &block
      script = javascript_tag do
        %Q{document.write("#{escape_javascript content}");}
      end
      concat script
    end
  end 

end