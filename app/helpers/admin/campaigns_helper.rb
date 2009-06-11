module Admin::CampaignsHelper

  # 'capture' and 'concat' are two helpers in ActionView to work with ERB
  def if_javascript(&block)
    concat(javascript_tag do
      %Q{document.write("#{escape_javascript capture(&block)}");}
    end) if block_given?
  end
  
  def no_javascript(&block)
    concat "<noscript>\n#{capture &block}\n</noscript>" if block_given?
  end
end