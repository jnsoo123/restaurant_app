module DeviseHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
  
  def devise_error_messages!
    return "" unless devise_error_messages?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, "<span style='margin-right: 10px;' class='glyphicon glyphicon-exclamation-sign' aria-hidden='true'></span>#{msg}".html_safe) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      :count => resource.errors.count,
                      :resource => resource.class.model_name.human.downcase)

    html = <<-HTML
    <div id="error_explanation" class="alert alert-danger" role="alert">
      <ul style='list-style-type: none'>#{messages}</ul>
    </div>
    
    HTML

    html.html_safe
  end

  def devise_error_messages?
    !resource.errors.empty?
  end
end