# Duplicated from twitter-bootstrap-rails gem.  Should be removed once
# twitter-bootstrap-rails handles this.  Also needs to be updated
# when twitter-bootstrap-rails is updated.
# REF: https://github.com/seyhunak/twitter-bootstrap-rails/issues/338
module BootstrapFlashHelper
  def bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      # Skip Devise :timeout flag
      next if type == :timeout
      type = :success if type == :notice
      type = :error   if type == :alert
      text = content_tag(:div, 
               content_tag(:button, raw("&times;"), :class => "close", "data-dismiss" => "alert") +
               message, :class => "alert fade in alert-#{type}")
      flash_messages << text if message
    end
    flash_messages.join("\n").html_safe
  end
end
