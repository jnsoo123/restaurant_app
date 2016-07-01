module ApplicationHelper
  def locale_name_pairs
    I18n.available_locales.map do |locale|
      [I18n.t('language', locale: locale), locale]
    end
  end
  
  def display_user(user)
    unless user.avatar.url.nil?
      user.avatar.url
    else
      'default_user.png'
    end
  end
  
  def display_resto(resto)
    unless resto.avatar.url.nil?
      resto.avatar.url  
    else
      "default_resto.gif"
    end
  end
  
  def display_cover(resto)
    unless resto.cover.url.nil?
      resto.cover.url
    else
      "default_cover.jpg"
    end
  end
  
  def filter_active_class(path, main = false)
    if main
      "active"
    else
      current_page?(path) ? "active" : ""
    end
  end
end
