module ApplicationHelper
  def flash_messages
    flash.collect { |type, msgs|
      content_tag(:div, msgs, class: "alert alert-default alert-#{type}")
    }.join('').html_safe
  end
end
